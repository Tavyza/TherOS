-- abyss window manager
-- loading libraries
local th   = require("theros")
local fs   = require("filesystem")
local gpu  = require("component").gpu
local cfg  = require("conlib")
local w, h = gpu.getResolution()
local e    = require("event")
local coro = require("coroutine")
local bkgclr, txtclr, _, _, _, _, appdir, _, _ = cfg.general()
local ver    = cfg.version()
running      = {}
local text = "Loading TherOS " .. ver
gpu.set((w/2)-(#text/2), h/2, text) -- set the loading message
gpu.setBackground(bkgclr) -- sets the background color to the config value
gpu.fill(1, 1, w, h, " ") -- clear the screen


--if not fs.exists("/sys/.config/pass") then
--end

-- this function will allow us to re-use old programs without having to completely rebuild them (though they will need to be adapted)
-- i've just gotten used to the way the regular way of building these programs are so i don't want to change that really
-- also i really REALLY do not want to rebuild everything. I already rebuilt the file manager and installer, that's enough for me
local function run(x, y, w, h, program, header) 
  th.dwindow(x, y, w, h, header)
  oldset = gpu.set
  oldfill = gpu.fill
  -- the next 2 functions just redefine gpu.set and gpu.fill to work within the window boundary instead of the entire screen.
  gpu.set = function(newX, newY, text)
    local adjX = newX + x 
    local adjY = newY + y 
    if adjX >= x and adjX < x + w and adjY >= y and adjY < y + h then
      oldset(adjX, adjY, text)
    end
  end
  gpu.fill = function(fillX, fillY, fillW, fillH, char)
    local adjX = fillX + x
    local adjY = fillY + y
    if adjX >= x and adjX + fillW - 1 < x + w and adjY >= y and adjY + fillH - 1 < y + h then
      oldfill(adjX, adjY, fillW, fillH, char)
    end
  end
  -- creating the coroutine for the app
  local approutine = coro.create(function()
    local good, err = th.run(program)
    if not good then
      th.popup("Error", "err", err)
    end
  end)
  table.insert(running, approutine)
  -- this loop runs both the host (the abyss window manager) and the program ran by this function
  while true do
    if not apprman(approutine) then break end
    -- below this point the abyss window manager continues to run in the background while the program is run
    -- the 0.1 makes the e.pull wait for 0.1 seconds and returns nil. This is so the entire program doesn't freeze while waiting for an event
    local event, _, tx, ty = e.pull(0.1, "touch")
    if event then
      -- window close button is 4 to the left of the top right corner
      if tx == w-4 and ty == y then
        break
      end
    end
    -- if the program is dead
    if coro.status(approutine) == "dead" then
      break
    end
  end
  -- reset gpu.set and gpu.fill else everything breaks
  gpu.set = oldset
  gpu.fill= oldfill
end

local function apprman(approutine)
  if coro.status(approutine) ~= "dead" then
    local good, err = coro.resume(approutine)
    if not good then th.popup("Error", "err", err) return false end
  end
  return true
end

-- next on the priority list:
--[[
- Make apps popup
- Make info popup
- Allow the relocation of a window on the screen
]]
local apps = {}
local function appmenu()
  for app in fs.list(appdir) do
    table.insert(apps, app)
  end
  table.sort(apps)
end
gpu.set(1, h, "[Apps]")
gpu.set(w-7, h, "[System]")
gpu.set(9, h, "[TASKS]")
baseline = h-#apps-1
x = 1
-- Main loop
while true do
  appmenu()
  for i = 1, #apps do
    gpu.set(1, baseline + i, "         ")
  end
  x = x + 1 
  -- Check for events
  local event, _, tx, ty = e.pull(0.1, "touch")
  if event then
    -- Close button logic
    if tx == w-4 and ty == y then
      break
    end
  end
  
  if event and tx >= 1 and tx <= 6 and ty == h-1 then -- if a click happened within the apps button
    for i, app in ipairs(apps) do -- go through app table
      gpu.set(1, baseline+i, "{" .. app .. "}") -- print the app
      if event and tx >= 1 and tx <= #app then
        run(5, 5, 60, 30, fs.concat(appdir, app), app)
      end
    end
  end

  -- Run existing coroutines for apps
  for i, app in ipairs(running) do
    local status = coro.status(app)

    if status ~= "dead" then
      local good, err = coro.resume(app)
      if not good then
        th.popup("Error", "err", err)
      end
    else
      table.remove(running, i) -- Remove dead coroutines
    end
  end
end