local fs = require("filesystem")
local gpu = require("component").gpu
local e = require("event")
local kb = require("keyboard")
local ct = require("centertext")
local th = require("theros")
local fsu = require("fsutils")
local shell = require("shell")
local conf = require("conlib")

local bkgclr, txtclr, _, sloclr, fmdclr, fmfclr, _, trmdir, editor = conf.general()
local _, _, fmver = conf.version()

local function clamp(value, min, max)
  if value < min then
    return max
  elseif value > max then
    return max
  else
    return value
  end
end

local w, h = gpu.getResolution()
local x = 1
local y = 1
gpu.setBackground(bkgclr)
local currentdir = "/"
local selection = 3

local function contextbar() -- loads a keybind bar at the bottom
  local contextbar = "Q: quit | T: terminal | N: new file | D: new directory"
  local fileselectioncontext = "R: run | E: edit | X: delete | M: move | C: copy"
  local dirselectioncontext = "R: open | M: move | C: copy | X: delete"

  if selectedfile and fs.isDirectory(selectedfile) then
    gpu.fill(1, h-2, w, h-2, " ")
    ct(h-2, dirselectioncontext, txtclr)
  elseif selectedfile and not fs.isDirectory(selectedfile) then
    gpu.fill(1, h-2, w, h-2, " ")
    ct(h-2, fileselectioncontext, txtclr)
  else
    gpu.fill(1, h-2, w, h-2, " ")
    ct(h-2, contextbar, txtclr)
  end
end

local function errorprompt(message)
  ct((h/2)-1, "-------------------------")
  ct(h/2, message)
  ct((h/2)+1, "-------------------------")
end
local function prompt(header, text)
  ct((h/2)-2, "-------------------------")
  ct((h/2)-1, header)
  ct((h/2), text)
  t.setCursor((w/2), (#"-------------------------"-#"-------------------------"))
  input = io.read()
  ct((h/2)+2, "-------------------------")
  return input
end

local function displayfiles(e)
  local files = {
    "../",
  }
  for file in fs.list(currentdir) do 
    table.insert(files, file)
  end
  for i, file in ipairs(files) do -- iterate through them damn files boi
    if fs.isDirectory(file) then
      color = fmdclr
    else
      color = fmfclr
    end
    if i == selection then
      gpu.setForeground(sloclr)
    end
    ct(2+i, file, color)
    gpu.set((w/2)-(#file/2), 2+i, file)
    gpu.set((w/2)-1, h-1, files[selection])
  end
  if e[1] == "key_down" and e[4] == kb.keys.up then
    selection = clamp(selection - 1, 1, #files)
  elseif e[1] == "key_down" and e[4] == kb.keys.down then
    selection = clamp(selection + 1, 1, #files)
  elseif e[1] == "key_down" and e[4] == kb.keys.enter then
    selectedfile = files[selection]
  end

  local keydown = e[1] == "key_down"

  if selectedfile ~= nil then
    if fs.isDirectory(selectedfile) then
      if e[1] == "key_down" and e[4] == kb.keys.r then
        currentdir = selectedfile
      elseif e[1] == "key_down" and e[4] == kb.keys.m then
        fsu.movedir()
    else
      if e[1] == "key_down" and e[4] == kb.keys.r then -- run
        local result, err = th.run(selectedfile)
        if not result then
          errorprompt(err)
        end
      elseif e[1] == "key_down" and e[4] == kb.keys.e then -- edit
        shell.execute(editor .. " " .. selectedfile) 
      elseif e[1] == "key_down" and e[4] == kb.keys.x then -- delete
        local input = prompt("DELETE", "Delete file? (y/N)")
        if input == "y" then
          fs.remove(selectedfile)
        else
          errorprompt("ERROR DELETING (Action denied)")
        end
      elseif e[1] == "key_down" and e[4] == kb.keys.m then -- move
        local input = prompt("MOVE", "New path and name:")
        fs.rename(selectedfile, input)
      elseif e[1] == "key_down" and e[4] == kb.keys.c then -- copy
        local input = prompt("COPY", "Copy destination:")
        fs.copy(selectedfile, input)
      end
    end
  end
end
end

local function closebutton()
  -- button position or smth
  gpu.set(w-3, y, "[x]")
end
gpu.fill(x, y, w, h, " ")
while true do -- should i do the loop?
  gpu.setForeground(0xFFFFFF)
  th.dwindow(x, y, w, h, "File Manager -- " .. currentdir)
  closebutton()
  contextbar()
  local event = table.pack(e.pull())
  displayfiles(event)
end