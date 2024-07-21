local component = require("component")
local gpu = component.gpu
local fs = require("filesystem")
local e = require("event")
local t = require("term")
local keyboard = require("keyboard")
local centerText = require("centerText")

local w, h = gpu.getResolution()
gpu.fill(1, 1, w, h, " ")

local function listFiles(currentPath)
    local files = {"../", "./"}
    for file in fs.list(currentPath) do
        table.insert(files, file)
    end
    return files
end

local function displayFiles(files, currentPath)
    t.clear()
    gpu.fill(1, 1, w, h, " ")
    centerText(1, "File Manager - " .. currentPath, 0xFFFFFF)
    for i, file in ipairs(files) do
        if fs.isDirectory(currentPath .. file) or file == "../" or file == "./" then
          color = 0x0000FF
        else
          color = 0x00FF00
        end
        centerText(3 + (i - 1) * 1, file, color)
    end
end

local function getFullPath(currentPath, file)
    if file == "../" then
        return fs.path(currentPath)
    elseif file == "./" then
        return currentPath
    else
        return fs.concat(currentPath, file)
    end
end

local currentPath = "/"
optionsDisplayed = false

local function displayCloseButton()
    local closeButton = "Close"
    centerText(h - 1, closeButton, 0xFFFFFF)
end

while true do
    ::loop::
    local files = listFiles(currentPath)
    displayFiles(files, currentPath)
    displayCloseButton()

    local _, _, _, y, _, _ = e.pull("touch")
    if y >= h - 1 then
        break
    end
    local choice = math.floor((y - 3) / 1) + 1

    if choice >= 1 and choice <= #files and not optionsDisplayed then
        local selectedFile = getFullPath(currentPath, files[choice])
        print(selectedFile)
        if fs.isDirectory(selectedFile) then
          if keyboard.isKeyDown(0x2A) == true then
            optionsDisplayed = true
            local options = {"Open","Move/Rename", "Copy", "Delete"}
            local optionSpacing = 2
            local startLine = h / 2 - (#options * optionSpacing) / 2
            for i, option in ipairs(options) do
              centerText(startLine + (i - 1) * optionSpacing, option, 0xFFFFFF)
            end
            local _, _, _, yOption, _, _ = e.pull("touch")
            local option = math.floor((yOption - startLine) / optionSpacing) + 1
            print("Selected option: " .. option)

            if option == 1 then
              print("Opening directory")
              currentPath = selectedFile
            elseif option == 2 then
              print("New path (DOES NOT WORK ACROSS DIFFERENT FILESYSTEMS)")
              io.write("LOCATION -> ")
              fs.rename(selectedFile, io.read())
            elseif option == 3 then
              print("Where would you like to copy this directory? This will copy all files within it.")
              io.write("LOCATION -> ")
              fs.copy(selectedFile, io.read())
            elseif option == 4 then
              print("Are you sure you want to delete this directory? This will also remove all items inside of it!")
              io.write("y/N -> ")
              confirm = io.read()
              if confirm == "y" then
                fs.remove(selectedFile)
              else
                print("Removal cancelled")
              end
              optionsDisplayed = false
            end
          else
          currentPath = selectedFile
          end
        else
          optionsDisplayed = true
          local options = {"Run", "Edit", "Copy", "Move/Rename", "Delete", "Cancel"}
          local optionSpacing = 2
          local startLine = h / 2 - (#options * optionSpacing) / 2
          for i, option in ipairs(options) do
            centerText(startLine + (i - 1) * optionSpacing, option, 0xFFFFFF)

          end

          local _, _, _, yOption, _, _ = e.pull("touch")

          local option = math.floor((yOption - startLine) / optionSpacing) + 1
          print("Selected option: " .. option)

          if option == 1 then
            print("Executing file: " .. selectedFile) 
            local ok, err = pcall(dofile(selectedFile))
            if not ok and err then
              print(err)
              io.write("ok")
              io.read()
            end
            elseif option == 2 then
              print("Editing file: " .. selectedFile) 
              os.execute("edit " .. selectedFile)
            elseif option == 3 then
              print("Enter copy destination: ")
              io.write("LOCATION -> ")
              fs.copy(selectedFile, io.read())
            elseif option == 4 then
              print("Enter new path/name: ") 
              io.write("LOCATION -> ")
              fs.rename(selectedFile, io.read())
            elseif option == 5 then
              print("Delete " .. selectedFile) 
              print("Are you sure you want to remove this file?")
              io.write("y/N -> ")
              if io.read() == "y" then
                fs.remove(selectedFile)
              else
                print("File not deleted.")
              end
            end
            optionsDisplayed = false
        end
    else
      optionsDisplayed = true
      local options = {"New file", "New directory"}
      local optionSpacing = 2
      local startLine = h / 2 - (#options * optionSpacing) / 2
      for i, option in ipairs(options) do
        centerText(startLine + (i - 1) * optionSpacing, option, 0xFFFFFF)
      end

      local _, _, _, yOption, _, _ = e.pull("touch")
      local option = math.floor((yOption - startLine) / optionSpacing) + 1
      print("Selected option " .. option)
      if option == 1 then
        print("New file name (INCLUDE EXTENTION)")
        io.write("-> ")
        newFile = io.read()
        local file, err = fs.open(currentPath .. "/" .. newFile, "w")
        file:close()
        if not file then
          print(err)
        end
      elseif option == 2 then
        print("New directory name")
        io.write("DIRECTORY -> ")
        fs.makeDirectory(currentPath .. "/" .. io.read() .. "/") 
        -- os.sleep(2) -- debug, i forget what for but i'll just leave this here
      end
      optionsDisplayed = false                
    end
end