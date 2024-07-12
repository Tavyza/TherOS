local fs = require("filesystem")
local t = require("term")
local e = require("event")
local shell = require("shell")
local component = require("component")
local gpu = component.gpu
local w, h = gpu.getResolution()

local installerversion = "TherOS 1.1"
local header = "TherOS Updater"

-- TEXT CENTERING
local function centerText(y, text, color)
  if color == nil then
    color = 0xFFFFFF
  end
  local x = math.floor(w / 2 - #text / 2)
  gpu.setForeground(color)
  gpu.set(x, y, text)
end

local function online()
  t.clear()
  centerText(1, "Please select branch: ")
  local branches = {
    "Main",
    "Bleeding Edge",
    "Unsupported versions",
    "Back to menu"
  }
  for i, branch in ipairs(branches) do
    centerText(3 + (i - 1) * 2, branch)
  end
  local _, _, _, y, _, _ = e.pull("touch")
  local choice = math.floor((y - 3) / 2) + 1
  local branch
  if choice == 1 then
    branch = "main"
  elseif choice == 2 then
    branch = "bleeding-edge"
  elseif choice == 3 then
    print("Feature not supported yet. (how ironic)\nMaybe this will be out by the time 1.1 goes on to the main branch.")
    return
  elseif choice == 4 then
    return "menu"
  end

  t.clear()
  io.write("Getting version...")
  shell.execute("wget -Q -f https://raw.githubusercontent.com/Tavyza/TherOS/" .. branch .. "/therosver /tmp/therosver")
  local file = io.open("/tmp/therosver", "r")
  local version = file:read("*a")
  file:close()
  io.write("Finding old version...")
  file = io.open("/sys/therosver", "r")
  local oldVersion = file:read("*a")
  file:close()

  if version ~= oldVersion then
    centerText(1, "Do you want to install " .. version .. "?")
    centerText(3, "Yes")
    centerText(5, "No")
    local _, _, _, y, _, _ = e.pull("touch")
    local choice = math.floor((y - 3) / 2) + 1
    if choice == 1 then
      t.clear()
      if fs.exists("/sys/apps/installer.lua") and installerversion ~= version then
        shell.execute("wget -Q -f https://raw.githubusercontent.com/Tavyza/TherOS/main/sys/apps/installer.lua")
        print("New installer pulled. Please close the installer and restart the installation process.")
        io.write("ok -> ")
        io.read()
        os.exit()
      end
      centerText(math.floor(h / 2), "PREPPING INSTALLATION...")
      print("Pre-installation questions. Type \"skip\" to skip the questions.")
      local chlg, therterm, manual, programInstaller
      if io.read() ~= "skip" then
        print("Y/n install changelog?")
        io.write("-> ")
        chlg = io.read()
        print("Option saved")
        print("Y/n install therterm?")
        io.write("-> ")
        therterm = io.read()
        print("Option saved")
        print("Y/n install manual?")
        io.write("-> ")
        manual = io.read()
        print("Option saved")
        print("Y/n online program installer?")
        io.write("-> ")
        programInstaller = io.read()
        print("Option saved")
        print("Pre-installation questions complete, proceeding with installation...")
      else
        print("Skipping, proceeding with installation...")
      end
      t.clear()
      centerText(math.floor(h / 2), "CREATING DIRECTORIES (1/2)...")
      if not fs.exists("/sys/apps/") then
        print("Creating /sys/apps/...")
        fs.makeDirectory("/sys/apps/")
      end
      if not fs.exists("/sys/env/") then
        print("Creating /sys/env/...")
        fs.makeDirectory("/sys/env/")
      end
      if not fs.exists("/sys/util/") then
        print("Creating /sys/util/")
        fs.makeDirectory("/sys/util/")
      end
      t.clear()
      centerText(math.floor(h / 2), "INSTALLING (2/2)...")
      local programs = {
        "/lib/centerText.lua",
        "/lib/filesystem_ext.lua",
        "/sys/apps/file_manager.lua",
        "/sys/apps/installer.lua",
        "/sys/apps/system_settings.lua",
        "/sys/env/main.lua",
        "/sys/thercon",
        "/sys/version",
        "/boot/94_therboot.lua"
      }
      if chlg ~= "n" then
        table.insert(programs, "/sys/changelog")
      end
      if therterm ~= "n" then
        table.insert(programs, "/sys/util/therterm.lua")
      end
      if manual ~= "n" then
        table.insert(programs, "/sys/apps/manual.lua")
      end
      if programInstaller ~= "n" then
        table.insert(programs, "/sys/apps/program_installer.lua")
      end

      for _, program in ipairs(programs) do
        print(program)
        shell.execute("wget -f -Q https://raw.githubusercontent.com/Tavyza/TherOS/" .. branch .. program .. " " .. program)
      end
      t.clear()
      centerText(math.floor(h / 2), "Finished! Reboot?")
      t.setCursor(math.floor((w / 2) - 8), math.floor(h / 2) + 1)
      io.write("Y/n -> ")
      if io.read() == "n" then
        os.exit()
      else
        require("computer").shutdown(true)
      end
    elseif choice == 2 then
      return "menu"
    end
  else
    centerText(1, "You are on the latest stable version of TherOS. Continue anyways?")
    centerText(3, "Yes")
    centerText(5, "No")
    local _, _, _, y, _, _ = e.pull("touch")
    local choice = math.floor((y - 3) / 2) + 1
    if choice == 1 then
      return "onlineinstall"
    elseif choice == 2 then
      return "menu"
    end
  end
end

local function onlineinstall()
  -- Online installation logic here
end

local function floppy()
  for address in component.list("filesystem") do
    local drive = component.proxy(address)
    if drive.exists("therosver") then
      fs.makeDirectory("/install/")
      fs.mount(address, "/install/")
      print("Mounted " .. address .. " to /install/.")
      local file = io.open("/install/sys/therosver")
      local version = file:read("*a")
      file:close()
      print("Valid filesystem found! Version: " .. version)
      install = true
    else
      print("No install media found!")
      install = false
    end
  end

  if install == false then
    print("Cannot install TherOS. No valid install media found.")
    os.sleep(2)
    os.exit()
  elseif install == true then
    print("Installation starting... checking integrity of install media...")
    t.clear()
    print("Pre-installation questions. Type \"skip\" to skip the questions.")
    local chlg, therterm, manual, programInstaller
    if io.read() ~= "skip" then
      print("Y/n install changelog?")
      io.write("-> ")
      chlg = io.read()
      print("Option saved")
      print("Y/n install therterm?")
      io.write("-> ")
      therterm = io.read()
      print("Option saved")
      print("Y/n install manual?")
      io.write("-> ")
      manual = io.read()
      print("Option saved")
      print("Y/n online program installer?")
      io.write("-> ")
      programInstaller = io.read()
      print("Option saved")
      print("Pre-installation questions complete, proceeding with installation...")
    else
      print("Skipping, proceeding with installation...")
    end
    t.clear()
    centerText(math.floor(h / 2), "CREATING DIRECTORIES (1/2)...")
    if not fs.exists("/sys/apps/") then
      print("Creating /sys/apps/...")
      fs.makeDirectory("/sys/apps/")
    end
    if not fs.exists("/sys/env/") then
      print("Creating /sys/env/...")
      fs.makeDirectory("/sys/env/")
    end
    if not fs.exists("/sys/util/") then
      print("Creating /sys/util/")
      fs.makeDirectory("/sys/util/")
    end
    t.clear()
    centerText(math.floor(h / 2), "INSTALLING (2/2)...")
    local programs = {
      "/lib/centerText.lua",
      "/lib/filesystem_ext.lua",
      "/sys/apps/file_manager.lua",
      "/sys/apps/installer.lua",
      "/sys/apps/system_settings.lua",
      "/sys/env/main.lua",
      "/sys/thercon",
      "/sys/version",
      "/boot/94_therboot.lua"
    }
    if chlg ~= "n" then
      table.insert(programs, "/sys/changelog")
    end
    if therterm ~= "n" then
      table.insert(programs, "/sys/util/therterm.lua")
    end
    if manual ~= "n" then
      table.insert(programs, "/sys/apps/manual.lua")
    end
    if programInstaller ~= "n" then
      table.insert(programs, "/sys/apps/program_installer.lua")
    end

    for _, program in ipairs(programs) do
      io.write("Checking for " .. program .. "...")
      if fs.exists("/install" .. program) then
        io.write("success!")
        fs.copy("/install" .. program, program)
      else
        io.write("Corrupt installation media. Aborting...")
        return "menu"
      end
    end
    t.clear()
    centerText(math.floor(h / 2), "Finished! Reboot?")
    t.setCursor(math.floor((w / 2) - 8), math.floor(h / 2) + 1)
    io.write("Y/n -> ")
    if io.read() == "n" then
      os.exit()
    else
      require("computer").shutdown(true)
    end
  end
end

local function menu()
  local options = {
    "Install/Update TherOS (Online)",
    "Install/Update TherOS (Floppy disk)",
    "Exit",
  }
  t.clear()
  centerText(1, header)
  for i, option in ipairs(options) do
    centerText(3 + (i - 1) * 2, option)
  end
  local _, _, _, y, _, _ = e.pull("touch")
  local choice = math.floor((y - 3) / 2) + 1
  if choice == 1 then
    online()
  elseif choice == 2 then
    floppy()
  elseif choice == 3 then
    os.exit()
  end
end

menu()
