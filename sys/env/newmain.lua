local event = require("event")
local term = require("term")
local component = require("component")
local gpu = component.gpu

while true do
    local event = table.pack(event.pull())
    gpu.setBackground(0x0D00B3)
    term.clear()
end