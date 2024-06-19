local fs = require("filesystem")
local ct = require("centerText")
local t = require("term")
local gpu = require("component").gpu
local e = require("event")
local kb = require("keyboard")
local shell = require("shell")

::inthebeginning::

local w, h = gpu.getResolution()
local currentDir = "/" -- sets to root dir at first, might change later

local function listFiles(currentDir)
  local files = {"../"} -- WHAT??? NO MORE "./"?? INSANI- shut, it was literally useless
  for file in fs.list(currentDir) do
    table.insert(files, file)
  end
  return files
end

local function displayFiles(files, currentDir) -- function to print out all files in the working directory
  t.clear()
  ct(1, "File Manager 1.1 : " .. currentDir) -- top text, might change
  for i, file in ipairs(files) do -- this just goes through the table
    local fullPath = fs.concat(currentDir, file)
    if fs.isDirectory(fullPath) then -- i really don't like this being here because it just doesn't work half the time
      color = 0x0000FF
    else
      color = 0x00FF00
    end
    ct(3 + (i - 1), file, color) -- well this just... prints the files
  end
end

local function getpath(currentDir, file)
  if file == "../" then
    return fs.path(currentDir)
  else
    return fs.concat(currentDir, file)
  end
end

local function close()
  ct(h - 1, "Exit")
end

local function executeWithErrorHandling(command)
  local result, error = pcall(shell.execute, command)
  if error then
    gpu.fill(60, 20, 100, 30, " ")
    ct(h / 2 + 5, "Error: " .. error, 0xFF0000)
    io.read()
  end
end

while true do -- loop to keep the program running
  local files = listFiles(currentDir)
  displayFiles(files, currentDir)
  close()

  local _, _, _, y = e.pull("touch")
  if y == h - 1 then
    break
  end

  local choice = y - 2
  if choice >= 1 and choice <= #files then
    local selectedFile = getpath(currentDir, files[choice])
    print(selectedFile) -- outputting selected file so you know what you clicked

    if fs.isDirectory(selectedFile) then
      if kb.isKeyDown(0x2A) then -- shift key
        local options = {"Open", "Copy", "Move/Rename", "Delete"}
        local startLine = h / 2 - (#options * 2)
        for i, option in ipairs(options) do
          ct(startLine + (i - 1) * 2, option)
        end

        local _, _, _, yOption = e.pull("touch")
        local optionChoice = math.floor((yOption - startLine) / 2) + 1

        if optionChoice == 1 then
          currentDir = selectedFile
        elseif optionChoice == 2 then
          gpu.fill(60, 20, 100, 30, " ")
          ct(h / 2, "Copying " .. selectedFile)
          ct((h / 2) + 1, "Type copy dest (note this does not work across separate drives.)")
          t.setCursor(70, 27)
          io.write("fullcopypath -> ")
          local ok, err = fs.copy(selectedFile, io.read())
          if not ok then
            ct((h / 2) + 5, "Error copying " .. selectedFile .. ": " .. err, 0xFF0000)
            io.read()
          end
        elseif optionChoice == 3 then
          gpu.fill(60, 20, 100, 30, " ")
          ct(h / 2, "Moving " .. selectedFile)
          ct((h / 2) + 1, "Type new path (note this does not work across separate drives.)")
          t.setCursor(70, 27)
          io.write("fullmovepath -> ")
          local ok, err = fs.rename(selectedFile, io.read())
          if not ok then
            ct((h / 2) + 5, "Error renaming " .. selectedFile .. ": " .. err, 0xFF0000)
            io.read()
          end
        elseif optionChoice == 4 then
          gpu.fill(60, 20, 100, 30, " ")
          ct(h / 2, "DELETE CONFIRM FOR " .. selectedFile)
          ct((h / 2) + 1, "Are you sure you want to delete " .. selectedFile .. " and everything in it? This action cannot be reversed!")
          t.setCursor(70, 27)
          io.write("yes/N")
          if io.read() == "yes" then
            local ok, err = fs.remove(selectedFile)
            if not ok then
              ct((h / 2) + 5, "Error deleting " .. selectedFile .. ": " .. err, 0xFF0000)
              io.read()
            end
          else
            ct((h / 2) + 5, "Error deleting " .. selectedFile .. ": Deletion cancelled", 0xFF0000)
            io.read()
          end
        end
      else
        currentDir = selectedFile
      end
    else
      local options = {"Run", "Edit", "Copy", "Move/Rename", "Delete"}
      local startLine = h / 2 - (#options * 2)
      for i, option in ipairs(options) do
        ct(startLine + (i - 1) * 2, option)
      end

      local _, _, _, yOption = e.pull("touch")
      local optionChoice = math.floor((yOption - startLine) / 2) + 1

      if optionChoice == 1 then -- run
        executeWithErrorHandling(selectedFile)
      elseif optionChoice == 2 then -- edit
        local ok, err = shell.execute("edit " .. selectedFile)
        if not ok then
          ct((h/2)+5,"Error editing " .. selectedFile .. ": " .. err, 0xFF0000)
          io.read()
        end
      elseif optionChoice == 3 then -- copy
        gpu.fill(60, 20, 100, 30, " ")
        ct(h / 2, "Type copy destination")
        t.setCursor(70, 27)
        io.write("fullcopydestination -> ")
        local ok, err = fs.copy(selectedFile, io.read())
        local err = "Error message could not load! You probably tried to copy to a directory that doesn't exist."
        if not ok then
          ct((h / 2) + 5, "Error copying " .. selectedFile .. ": " .. err, 0xFF0000)
          io.read()
        end
      elseif optionChoice == 4 then -- move
        gpu.fill(60, 20, 100, 30, " ")
        ct(h / 2, "Type new name/location")
        t.setCursor(70, 27)
        io.write("renamedfilename -> ")
        local ok, err = fs.rename(selectedFile, io.read())
        if not ok then
          ct((h / 2) + 5, "Error renaming " .. selectedFile .. ": " .. err, 0xFF0000)
          io.read()
        end
      elseif optionChoice == 5 then -- delete
        gpu.fill(60, 20, 100, 30, " ")
        ct(h / 2, "DELETE CONFIRM FOR " .. selectedFile)
        ct((h / 2) + 1, "Are you sure you want to delete " .. selectedFile .. "? This action cannot be reversed!")
        t.setCursor(70, 27)
        io.write("yes/N")
        if io.read() == "yes" then
          local ok, err = fs.remove(selectedFile)
          if not ok then
            ct((h / 2) + 5, "Error deleting " .. selectedFile .. ": " .. err, 0xFF0000)
            io.read()
          end
        else
          ct((h / 2) + 5, "Error deleting " .. selectedFile .. ": Deletion cancelled", 0xFF0000)
          io.read()
        end
      end
    end
  else
    local options = {"New File", "New Directory"}
    local startLine = h / 2 - (#options * 2)
    for i, option in ipairs(options) do
      ct(startLine + (i - 1) * 2, option)
    end

    local _, _, _, yOption = e.pull("touch")
    local optionChoice = math.floor((yOption - startLine) / 2) + 1

    if optionChoice == 1 then -- new file
      gpu.fill(60, 20, 100, 30, " ")
      ct(h / 2, "Type new file name")
      t.setCursor(70, 27)
      io.write("newfilename -> ")
      local newFile = io.read()
      local file, err = fs.open(fs.concat(currentDir, newFile), "w")
      if not file then
        ct((h / 2) + 5, "Error creating new file: " .. err, 0xFF0000)
        io.read()
      else
        file:close()
      end
    elseif optionChoice == 2 then -- new dir
      gpu.fill(60, 20, 100, 30, " ")
      ct(h / 2, "Type new directory name")
      t.setCursor(70, 27)
      io.write("newdirname -> ")
      local ok, err = fs.makeDirectory(fs.concat(currentDir, io.read()))
      if not ok then
        ct((h / 2) + 5, "Error creating new directory: " .. err, 0xFF0000)
        io.read()
      end
    end
  end
end