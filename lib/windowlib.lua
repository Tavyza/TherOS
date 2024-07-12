local gpu = require("component").gpu
local w, h = gpu.getResolution()
local e = require("event")

function drawWindow(x, y, w, h, titletext)
  gpu.fill(x,y,w,1,"═") -- top
  gpu.fill(x,y+h-1,w,h,"═") -- bottom
  gpu.fill(x,y,1,h,"║") -- left
  gpu.fill(x+w-1,1,w,h,"║") -- right
  gpu.set(x,y,"╔") -- top left corner
  gpu.set(x+w-1,y,"╗") -- top right corner
  gpu.set(x,y+h-1,"╚") -- bottom left corner
  gpu.set(x+w-1,y+h-1,"╝") -- bottom right corner

  gpu.set(math.floor(w/2)-math.floor(#titletext/2), 1, "[" .. titletext .. "]") -- setting the top text at the middle of the top
  --gpu.setForeground(0xFF0000) --red
  --gpu.set(w-4,1,"[X]") -- close button (commented for now because it doesn't work)
  --local _, x, y, button, _ = e.pull("touch") -- grabbing touch signal
  --if x == w-4 and y == 1 then --
  --  os.exit()
  --end
  return {x = x, y = y, w = w, h = h}
end