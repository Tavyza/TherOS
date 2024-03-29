local component = require("component")
local gpu = component.gpu
local fs = require("filesystem")
local e = require("event")
local t = require("term")

local w, h = gpu.getResolution()
gpu.fill(1, 1, w, h, " ")

local function centerText(y, text, color)
    local x = math.floor(w / 2 - #text / 2)
    gpu.setForeground(color)
    gpu.set(x, y, text)
end

local function installerMenu()
    local options = {"Install TherOS", "Install TherOS from GitHub", "Install a Separate Program", "Exit Installer"}
    t.clear()
    gpu.fill(1, 1, w, h, " ")
    centerText(1, "TherOS 0.2.0 Installer", 0xFFFFFF)
    for i, option in ipairs(options) do
        centerText(3 + (i - 1) * 2, option, 0xFFFFFF)
    end
end

local function installTherOS()
  print("Welcome to the TherOS installer version 0.2.0. Please wait while the program gathers the system files.")
  local scriptPath = "/mnt/---"
  local scriptId = "---" --modify if this changes to a seperate floppy
  print("drive id is " .. scriptId)
  print("Script path:", scriptPath)
  for entry in fs.list(scriptPath) do
    local source = scriptPath
    local dest = "/home/bin"
    if fs.exists("/home/bin") and fs.isDirectory("/home/bin") then
      print("'bin' directory detected, proceeding...")
    else
      print("'bin' directory not detected, creating...")
      os.execute("mkdir /home/bin")
      print("created 'bin' directory (used for apps)")
    end
    print("copying main menu...")
    os.execute("cp /mnt/" .. scriptId .. "/main.lua  " .. dest)
    print("done")
    print("copying file manager...")
    os.execute("cp /mnt/" .. scriptId .. "/file_manager.lua  " .. dest)
    print("done")
    print("copying program installer...")
    os.execute("cp /mnt/" .. scriptId .. "/program_installer.lua  " .. dest)
    print("done")
    print("copying command prompt...")
    os.execute("cp /mnt/" .. scriptId .. "/command_prompt.lua  " .. dest)
    print("done")
    print("copying file creator...")
    os.execute("cp /mnt/" .. scriptId .. "/create_file.lua  " .. dest)
    print("done")
    print("copying OS installer...")
    os.execute("cp /mnt/" .. scriptId .. "/installer.lua  " .. dest)
    print("done")
    print("copying TherOS text adventure...")
    os.execute("cp /mnt/" .. scriptId .. "/hello.lua  " .. dest)
    print("done")
    print("copying changelog.txt...")
    os.execute("cp /mnt/" .. scriptId .. "/changelog.txt " .. dest)
    print("done")
    print("copying new .shrc...")
    os.execute("cp /mnt/" .. scriptId .. "/.shrc " .. "/home")
    print("done")
  end
    centerText(h - 2, "Installation complete. Ready for reboot.", 0xFFFFFF)
    os.sleep(2)
    os.execute("reboot")
end

local function installFromGithub()
  print("Welcome to the TherOS installer version 0.2.0. Please wait while the program gathers the system files.")
  local source = scriptPath
  local dest = "/home/bin"
  if fs.exists("/home/bin") and fs.isDirectory("/home/bin") then
    print("'bin' directory detected, proceeding...")
  else
    print("'bin' directory not detected, creating...")
    os.execute("mkdir /home/bin")
    print("created 'bin' directory (used for apps)")
  end
  print("downloading main menu...")
  os.execute("wget -f https://raw.githubusercontent.com/Tavyza/TherOS/main/main.lua /home/bin/main.lua")
  print("downloading file manager...")
  os.execute("wget -f https://raw.githubusercontent.com/Tavyza/TherOS/main/file_manager.lua /home/bin/file_manager.lua")
  print("downloading program installer...")
  os.execute("wget -f https://raw.githubusercontent.com/Tavyza/TherOS/main/program_installer.lua /home/bin/program_installer.lua")
  print("downloading command prompt...")
  os.execute("wget -f https://raw.githubusercontent.com/Tavyza/TherOS/main/command_prompt.lua /home/bin/command_prompt.lua")
  print("downloading file creator...")
  os.execute("wget -f https://raw.githubusercontent.com/Tavyza/TherOS/main/create_file.lua /home/bin/create_file.lua")
  print("downloading OS installer...")
  os.execute("wget -f https://raw.githubusercontent.com/Tavyza/TherOS/main/installer.lua /home/bin/installer.lua")
  print("downloading TherOS text adventure...")
  os.execute("wget -f https://raw.githubusercontent.com/Tavyza/TherOS/main/hello.lua /home/bin/hello.lua")
  print("downloading changelog.txt...")
  os.execute("wget -f https://raw.githubusercontent.com/Tavyza/TherOS/main/changelog.txt /home/bin/changelog.txt")
  print("replacing .shrc")
  os.execute("wget -f https://raw.githubusercontent.com/Tavyza/TherOS/main/.shrc /home/.shrc")
  centerText(h - 2, "Installation complete. Ready for reboot.", 0xFFFFFF)
  os.sleep(2)
  os.execute("reboot")
end

local function installSeparateProgram()
  print("Please type the drive ID. you can find this by leaving the screen, hovering over the drive, and looking at the first 3 characters of the long string in the tooltip of the drive (the thing with the name and stuff)")
  io.write("drive ID -> ")
  local installMedia = io.read()
  print ("Getting files...")
  local sourcedir = "/mnt/" .. installMedia
  local destdir = "/home/"
  -- Iterate through all files in the source directory
  for entry in fs.list(sourcedir) do
    local sourcePath = sourcedir .. "/" .. entry
    local destinationPath = destdir .. "/" .. entry
    if not fs.isDirectory(sourcePath) then
      fs.copy(sourcePath, destinationPath)
    end
  end
end
  centerText(h - 2, "Files copied successfully.", 0xFFFFFF)


installerMenu()

while true do
    local _, _, _, y, _, _ = e.pull("touch")
    local choice = math.floor((y - 3) / 2) + 1
    if choice == 1 then
        installTherOS()
    elseif choice == 2 then
        installFromGithub()
    elseif choice == 3 then
      installSeparateProgram()
    elseif choice == 4 then
        os.execute("sh")
        break
    end
    installerMenu()
end
