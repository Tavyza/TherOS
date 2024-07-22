local component = require("component")
local gpu = component.gpu
local c = require("computer")
local fs = require("filesystem")
local e = require("event")
local t = require("term")
local centerText = require("centertext")

local appdir = "/sys/apps"

local w, h = gpu.getResolution()
gpu.fill(1, 1, w, h, " ")

local function updateOptions()
    local luaFiles = {}
    for file in fs.list("/sys/apps") do
        if (file:sub(-4) == ".lua" or file:sub(-4) == ".txt") and file ~= "main.lua" then
            table.insert(luaFiles, file:sub(1, -5))
        end
    end
    return luaFiles
end

local function displaySystemInfo()
    local memCap = math.floor(c.totalMemory() / 1000)
    local memUsed = math.floor(memCap - (c.freeMemory() / 1000))
    centerText(h - 3, "Uptime: " .. c.uptime() .. " sec")
    centerText(h - 2, "Total RAM: " .. memCap .. " KB", 0xFFFFFF)
    centerText(h - 1, "Used RAM: " .. memUsed .. " KB", 0xFFFFFF)
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
local topText = "TherOS 1.1"

displayMenu(options, topText)

local lastAppUpdate = c.uptime()
local lastMemUpdate = c.uptime()

while true do
    local uptime = c.uptime()
    if uptime - lastAppUpdate >= 10 then
        options = updateOptions()
        table.insert(options, "reboot")
        table.insert(options, "shutdown")
        lastAppUpdate = uptime
        displayMenu(options, topText)
    end

    if uptime - lastMemUpdate >= 1 then
        displaySystemInfo()
        lastMemUpdate = uptime
    end

    local event = {e.pull(1)}
    if event[1] == "touch" then
        local _, _, x, y = table.unpack(event)
        local choice = math.floor((y - 3) / 2) + 1
        if choice >= 1 and choice <= #options then
            local selectedOption = options[choice]
            if selectedOption == "reboot" then
                c.shutdown(true)
            elseif selectedOption == "shutdown" then
                c.shutdown()
            else
                os.execute(appdir .. "/" .. selectedOption)
                displayMenu(options, topText)
            end
        end
    end
end
