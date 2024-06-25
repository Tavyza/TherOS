-- TEXT CENTERING
local gpu = require("component").gpu

local w, h = gpu.getResolution()

local configlines = {}

function centerText(y, text, color)
  if color == nil or color == "" then
    local file = io.open("/sys/thercon")
    for line in ipairs(file:lines()) do
      table.insert(configlines, line)
    end
    file:close()
    color = tonumber(configlines[16])
  end
  local x = math.floor(w / 2 - #text / 2)
  gpu.setForeground(color)
  gpu.set(x, y, text)
end

return centerText