-- TherOS text centering library
local gpu = require("component").gpu
local conf = require("tc-read")

local w, h = gpu.getResolution()
local txtclr = tonumber(conf.getvalue("/sys/.config/general.tc", "Txt-clr"))

centertext = {}
function centertext(y, text, color)
  if text ~= nil then
    color = color or txtclr
    gpu.setForeground(color)
    gpu.set((w/2)-(#text/2), y, text)
  else
    print("nil value")
  end
end
return centertext