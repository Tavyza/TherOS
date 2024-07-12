local fs = require("filesystem")
local gpu = require("component").gpu
local e = require("event")
local kb = require("keyboard")
local ct = require("centertext")
require("windowlib")
require("/config/thercon")

local bkgclr, txtclr, _, _, fmdclr, fmfclr, _, trmdir = config()

local e = require("event")
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
      if fs.isDirectory(files[selection]) then
        gpu.setForeground(0x619EFF)
      else
        gpu.setForeground(0xFAA501)
      end
    end
    ct(2+i, file, color)
    gpu.set((w/2)-(#file/2), 2+i, file)
    local selection = tostring(selection)
    gpu.set((w/2)-1, h-1, selection)
  end
  if e[1] == "key_down" and e[4] == kb.keys.up then
    selection = selection - 1
  elseif e[1] == "key_down" and e[4] == kb.keys.down then
    selection = selection + 1
  elseif e[1] == "key_down" and e[4] == kb.keys.enter then
    selectedfile = " *" .. files[selection]
  end

  if selectedFile ~= nil then
    if fs.isDirectory(selectedFile) then
      if e[1] == "key_down" and e[4] == kb.keys.r then
        currentdir = selectedfile
      elseif e[1] == "key_down" and e[4] == kb.keys.m then

  end
end

local function closebutton()
  -- button position or smth
  gpu.set(w-3, y, "[x]")
end
gpu.fill(x, y, w, h, " ")
while true do -- should i do the loop?
  gpu.setForeground(0xFFFFFF)
  drawWindow(x, y, w, h, "File Manager -- " .. currentdir)
  closebutton()
  contextbar()
  local event = table.pack(e.pull())
  displayfiles(event)
end