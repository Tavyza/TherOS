-- TherOS text centering library
local gpu = require("component").gpu
require("thercon")

local w, h = gpu.getResolution()
local _, txtclr, _, _, _, _, _, _ = config()

function centertext(y, text, color)
  if color == "" then
    color = txtclr
  end
  gpu.setForeground(color)
  gpu.set((w/2)-(#text/2), y, text)
end
