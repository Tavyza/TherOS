-- therOS updater

-- making the TherOS libs here as they are not available.
local gpu = require("component").gpu
local w, h = gpu.getResolution()
local e = require("event")
local kb = require("keyboard")
local t = require("term")

local function drawWindow(x, y, w, h, titletext) -- window lib
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
local txtclr = 0xFFFFFF

local function ct(y, text, color) -- centertext lib
  if color == "" then
    color = txtclr
  end
  gpu.setForeground(color)
  gpu.set((w/2)-(#text/2), y, text)
end

drawWindow(1, 1, w, h, "Updater 2.0.0")

local function menu()

end

local function from_floppy()
  drawWindow(1, 1, w, h, "Updater -- Install TherOS from floppy")
  ct(h/2, "Feature currently unavailable.")
  io.read()
end

local function from_git()
  drawWindow(1, 1, w, h, "Updater -- Install TherOS from GitHub")
  ct(3, "Choose branch")
  local branches = {"Main", "Bleeding Edge"}
  for i, branch in ipairs(branches) do
    ct(2+i, branch)
  end
  local keydown = e[1] == "key_down"
  if keydown and kb.keys.up then
    local choice = choice - 1
  elseif keydown and kb.keys.down then
    local choice = choice + 1
  elseif keydown and kb.keys.enter then
    branch = choice
  end
  drawWindow((w/2)-10, (h/2)-2, (w/2)+10, (h/2)+2, "INSTALL CONFIRM")
  local prompt = "Install TherOS?"
  ct((h/2)-1, prompt)
  t.setCursor((w/2)-4, (h/2))
  io.write("Y/n -> ")
  if io.read() == "n" then
    os.exit()
  end
end