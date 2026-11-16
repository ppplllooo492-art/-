--[[
    ROX + MV Alphanumeric 199-Chunk ZIP Loader (V4 Lossless UTF-8 & Precision Sync)
    วางไฟล์ "MV_Vault_199.zip" ในโฟลเดอร์ Workspace ของตัวรัน
]]

local ZIP_FILE = "MV_Vault_199.zip"
local XOR_KEY = 89
local MV_OFFSET = 1540
local EXPECTED_BYTES = 45841
local EXPECTED_HASH = 2728957223

if not isfile or not readfile then
    return warn("[MV Loader] Error: Executor ของคุณไม่รองรับคำสั่ง isfile หรือ readfile")
end

if not isfile(ZIP_FILE) then
    return warn("[MV Loader] Error: ไม่พบไฟล์ '" .. ZIP_FILE .. "' ในโฟลเดอร์ Workspace!")
end

local rawZip = readfile(ZIP_FILE)
if not rawZip or #rawZip < 100 then
    return warn("[MV Loader] Error: ไฟล์ ZIP เสียหายหรืออ่านข้อมูลได้ไม่ครบ")
end

local bxor = (bit32 and bit32.bxor) or (bit and bit.bxor) or function(a, b)
    local res, bitval = 0, 1
    while a > 0 or b > 0 do
        if (a % 2) ~= (b % 2) then res = res + bitval end
        a = math.floor(a / 2)
        b = math.floor(b / 2)
        bitval = bitval * 2
    end
    return res
end

local function extractZipFiles(bin)
    local files = {}
    local pos = 1
    local len = #bin
    local count = 0

    local function u16(o)
        local b1, b2 = bin:byte(o, o + 1)
        return (b1 or 0) + ((b2 or 0) * 256)
    end

    local function u32(o)
        local b1, b2, b3, b4 = bin:byte(o, o + 3)
        return (b1 or 0) + ((b2 or 0) * 256) + ((b3 or 0) * 65536) + ((b4 or 0) * 16777216)
    end

    while pos <= len - 30 do
        local sig = u32(pos)
        if sig == 0x04034b50 then
            local compSize = u32(pos + 18)
            local nameLen = u16(pos + 26)
            local extraLen = u16(pos + 28)

            local nameStart = pos + 30
            local fileName = bin:sub(nameStart, nameStart + nameLen - 1)
            local dataStart = nameStart + nameLen + extraLen
            local fileData = bin:sub(dataStart, dataStart + compSize - 1)

            files[fileName] = fileData
            count = count + 1
            pos = dataStart + compSize
        else
            break
        end
    end
    return files, count
end

local extracted, fileCount = extractZipFiles(rawZip)
if fileCount < 199 then
    return warn("[MV Loader] Error: แตกไฟล์ได้ไม่ครบ 199 ไฟล์ (พบ " .. tostring(fileCount) .. " ไฟล์)")
end

local B36_MAP = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
local function decodeBase36(str)
    local total = 0
    for i = 1, #str do
        local ch = str:sub(i, i)
        local idx = B36_MAP:find(ch, 1, true)
        if idx then
            total = (total * 36) + (idx - 1)
        end
    end
    return total
end

local outputChars = {}
local outCount = 0
local globalIndex = 1
local djb2Hash = 5381

for i = 1, 199 do
    local partName = string.format("p_%03d.txt", i)
    local chunkData = extracted[partName]
    
    if chunkData and #chunkData >= 7 then
        for p = 1, #chunkData - 6, 7 do
            local token = chunkData:sub(p, p + 6)
            local coreB36 = token:sub(3, 5)
            local numVal = decodeBase36(coreB36)
            
            local unshifted = numVal - MV_OFFSET - (globalIndex % 31)
            local origByte = bxor(unshifted, XOR_KEY)
            
            if origByte >= 0 and origByte <= 255 then
                outCount = outCount + 1
                outputChars[outCount] = string.char(origByte)
                djb2Hash = ((djb2Hash * 33) + origByte) % 4294967296
            else
                return warn("[MV Loader] Error: พบไบต์ผิดพลาดที่ตำแหน่ง " .. tostring(globalIndex))
            end
            globalIndex = globalIndex + 1
        end
    end

    if i % 50 == 0 then
        task.wait()
    end
end

if outCount ~= EXPECTED_BYTES or djb2Hash ~= EXPECTED_HASH then
    return warn(string.format("[MV Loader] Integrity Failed! ขนาด: %d/%d | Hash: %d/%d", outCount, EXPECTED_BYTES, djb2Hash, EXPECTED_HASH))
end

local finalSource = table.concat(outputChars, "", 1, outCount)

-- รอความพร้อมของเกมและ PlayerGui ก่อนรันสคริปต์ UI
if not game:IsLoaded() then
    game.Loaded:Wait()
end
local Players = game:GetService("Players")
local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
local pgui = lp:WaitForChild("PlayerGui", 15)
if not pgui then
    warn("[MV Loader] Warning: PlayerGui โหลดช้ากว่าปกติ กำลังดำเนินการต่อ...")
end
task.wait(0.25)

local runFunc, err = loadstring(finalSource)
if runFunc then
    print("[MV Loader] โหลดและตรวจสอบความถูกต้องสำเร็จ 100% (" .. tostring(outCount) .. " bytes)")
    task.spawn(runFunc)
else
    warn("[MV Loader] Syntax Error ในโค้ดต้นฉบับ: " .. tostring(err))
end
