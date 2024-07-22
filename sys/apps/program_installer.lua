local t = require("term")
local ct = require("centertext")
local e = require("event")
local conf = require("conlib")
local th = require("theros")
local bkgclr, txtclr = conf.general()
gpu = require("component").gpu
local w, h = gpu.getResolution()


t.clear()
gpu.setBackground(bkgclr)
gpu.setForeground(txtclr)
local function menu()
  local options = {"Install from Pastebin", "Install from other source"}
  t.clear()
  th.dwindow(1, 1, w, h, "TherOS app installer")
  for i, options in ipairs(options) do
    ct(5 + (i - 1) * 2, options, 0xFFFFFF)
  end
end

local function pastebin()
  local code = th.popup("Pastebin code", "input", "Enter pastebin code: ")
  local name = th.popup("File name", "input", "Enter desired file name: ")
  os.execute("pastebin get " .. code .. " " .. name)
  os.exit()
end
local function github()
  local link = th.popup("Link", "input", "Enter link: ")
  local gName = th.popup("File name", "input", "Enter desired file name: ")
  os.execute("wget " .. link .. " " .. gName)
  os.exit()
end

local function floppy()
  drives = component.list("filesystem")
end

while true do
  menu()
  local _, _, _, y, _, _ = e.pull("touch")
  local choice = math.floor((y - 5) / 2) + 1
  if choice == 1 then
    pastebin()
  elseif choice == 2 then
    github()
  end
  menu()
end