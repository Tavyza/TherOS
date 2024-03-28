local component = require("component")
local gpu = component.gpu
local c = require("computer")
local fs = require("filesystem")
local e = require("event")
local t = require("term")

local w, h = gpu.getResolution()
gpu.fill(1, 1, w, h, " ")

local function centerText(y, text, color)
    local x = math.floor(w / 2 - #text / 2) -- Ensure x is an integer
    gpu.setForeground(color)
    gpu.set(x, y, text)
end

local function updateOptions()
    local luaFiles = {}
    for file in fs.list("home/bin") do
        if (file:sub(-4) == ".lua" or file:sub(-4) == ".txt") and file ~= "main.lua" then
            table.insert(luaFiles, file:sub(1, -5))
        end
    end
    return luaFiles
end

local function displaySystemInfo()
    local memCap = math.floor(c.totalMemory() / 1000)
    local memUsed = math.floor(memCap - (c.freeMemory() / 1000))
    local ramUnitCap = memCap >= 1000 and "MB" or "KB"
    local ramUnitUsed = memUsed >= 1000 and "MB" or "KB"

    centerText(h - 2, "Total RAM: " .. memCap .. " " .. ramUnitCap, 0xFFFFFF)
    centerText(h - 1, "Used RAM: " .. memUsed .. " " .. ramUnitUsed, 0xFFFFFF)
end

local function displayMenu(options, topText)
    t.clear()
    gpu.fill(1, 1, w, h, " ")
    centerText(1, topText, 0xFFFFFF)
    displaySystemInfo()
    for i, option in ipairs(options) do
        centerText(3 + (i - 1) * 2, option, 0xFFFFFF)
    end
end
local options = updateOptions()
table.insert(options, "reboot")
table.insert(options, "shutdown")
local topText = "TherOS 0.2.1 - Beta Version"

displayMenu(options, topText)

while true do
    local _, _, x, y, _, _ = e.pull("touch")

    local choice = math.floor((y - 3) / 2) + 1
    if choice >= 1 and choice <= #options then
        local selectedOption = options[choice]
        if selectedOption == "reboot" then
            os.execute("reboot")
        elseif selectedOption == "shutdown" then
            c.shutdown()
        else
            os.execute("/home/bin/" .. selectedOption .. ".lua")
            displayMenu(options, topText)
        end
    end
end
