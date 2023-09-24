term = require("term")
filesystem = require("filesystem")


term.clear()

print("What are you installing?")
print("TherOS (1)")
print("A seperate program (2)")
io.write("-> ")
local installFile = io.read()
if installFile == "1" then
  print("Welcome to the TherOS installer version 0.1. Please wait while the program gathers the system files.")
  local scriptPath = "/mnt/bb7"
  local scriptId = "bb7" --modify if this changes to a seperate floppy
  print("drive id is " .. scriptId)
  print("Script path:", scriptPath)
  for entry in filesystem.list(scriptPath) do
    local source = scriptPath 
    local dest = "/home/bin"
    if filesystem.exists("/home/bin") and filesystem.isDirectory("/home/bin") then
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
    print("copying offline installer...")
    os.execute("cp /mnt/" .. scriptId .. "/installer.lua  " .. dest)
    print("done")
    print("copying TherOS text adventure...")
    os.execute("cp /mnt/" .. scriptId .. "/hello.lua  " .. dest)
    print("done")
    print("copying changelog.txt...")
    os.execute("cp /mnt/" .. scriptId .. "/changelog.txt " .. dest)
    print("done")
    local homeDirectory = "/home/"
    local shrcPath = "/home/.shrc"
    local file, err = io.open(shrcPath, "a")
    local ee = file:read("*all")
    print("reading .shrc. if its blank, the installer will write to it. if the line needed is already there, the installer will skip it.")
    if shrcPath:find("main", 1, true) then
      print("shrc already written")
      file:close()
    else
      file:write("main\n")
      print("Wrote main to " .. shrcPath)
      file:close()  
    end
    print("Done! Ready for reboot.")
    io.write("System files copied. Reboot now? (y/n)-> ")
    local reboot = io.read()
    if reboot == "y" then
      print("rebooting in 5 seconds")
      os.sleep(1)
      print("rebooting in 4 seconds")
      os.sleep(1)
      print("rebooting in 3 seconds")
      os.sleep(1)
      print("rebooting in 2 seconds")
      os.sleep(1)
      print("rebooting in 1 seconds")
      os.sleep(1)
      print("rebooting...")
      os.execute("reboot")
    else
      print("Alright, returning to shell.")
    os.sleep(1)
    os.exit()
  end
end
elseif installFile == "2" then
  print("Please type the drive ID. you can find this by leaving the screen, hovering over the drive, and looking at the first 3 characters of the long string in the tooltip of the drive (the thing with the name and stuff)")
  io.write("driveID -> ")
  local installMedia = io.read()
  print ("Getting files...")
  local sourcedir = "/mnt/" .. installMedia
  local destdir = "/home/"
  -- Iterate through all files in the source directory
  for entry in filesystem.list(sourcedir) do
    local sourcePath = sourcedir .. "/" .. entry
    local destinationPath = destdir .. "/" .. entry  
    if not filesystem.isDirectory(sourcePath) then
      filesystem.copy(sourcePath, destinationPath)
    end
  end
end