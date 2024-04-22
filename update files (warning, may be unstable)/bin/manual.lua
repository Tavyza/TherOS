local ct = require("centerText")
local t = require("term")
local component = require("component")
local gpu = component.gpu
local e = require("event")

local w, h = gpu.getResolution()
gpu.fill(1, 1, w, h, " ")
t.clear()
local options = {"Introduction", "File manager", "Main System", "Libraries"}
gpu.fill(1, 1, w, h, " ")
for i, options in ipairs(options) do
  centerText(3 + (i - 1) * 2, options, 0xFFFFFF)
end

local function showOptions()
  centerText(1, "Manual", 0xFFFFFF)
  local _, _, _, y, _, _ = e.pull("touch")
  local choice = math.floor((y - 3) / 2) + 1
  if choice == 1 then
    intro()
  elseif choice == 2 then
    fileManager()
  elseif choice == 3 then
    mainSystem()
  elseif choice == 4 then
    lib()
  end
end

local function exitButton()
  centerText(h - 1, "Exit", 0xFFFFFF)
  if y >= h - 1 then
     showOptions()
  end
end

local function intro()
  centerText(1, "-- Introduction to TherOS --", 0xFFFFFF)
  print("TherOS is a lightweight and easy to use OS for Opencomputers. MineOS is too laggy, OpenOS is not easy for someone to get used to, so this gets a nice middle ground. TherOS basically adds a nice graphical interface to the default OpenOS to make it easier for everyone to use.\n\nTherOS was created by the Tavȳza organization.")
  exitButton()
end

local function fileManager()
  centerText(1, "-- File Manager --", 0xFFFFFF)
  print("The TherOS file manager is a dedicated app for managing all of the files on your computer. It uses a graphical interface to make managing your files easier.")
  print("The file manager may have a few controls that one may not be used to. This article is meant to explain them.")
  print(" ")
  print("If you click on a file, it will open a menu of actions that you can use to run, rename, move, delete, or copy the file.")
  print(" ")
  print("If you shift+click a directory, it will allow you to delete it or open it. Just clicking on it will open it.")
  print(" ")
  print("If you click on the blank space below the list of files, it will allow you to make a file or directory.")
  exitButton()
end  

local function mainSystem()
  exitButton()
end

local function lib()
  exitButton()
end

showOptions()
