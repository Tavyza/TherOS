local event = require("event")
local term = require("term")
local component = require("component")
local gpu = component.gpu

local options = {}

table.insert(options, "test option one")
table.insert(options, "test option two")
table.insert(options, "test option three")

while true do
    local event = table.pack(event.pull())
    local w, h = gpu.getResolution()
    gpu.fill(1, 1, w, h, " ")

    for _, option in ipairs(options) do
        io.write(option)
    end
end