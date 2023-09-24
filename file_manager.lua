term = require("term")
local filesystem = require("filesystem")

while true do
  term.clear()
  print("file manager v0.1.0. note: alpha release, please report any bugs to the tech shop in Riverside. \nPlease type in a number to select a file.")
  print("press enter with nothing typed in to return to home")
  print("press ctrl+alt+c to completely exit TherOS")
  local files = {"../", "./"}

  local lsOutput = io.popen("ls")
  for file in lsOutput:lines() do
     table.insert(files, file)
  end
  lsOutput:close()

  local pwd = io.popen("pwd")
  for line in pwd:lines() do
    print(line)
  end
  pwd:close()
  
  for i, file in ipairs(files) do
    if file:match("/$") then
      print("\27[34m" .. i .. ". " .. file .. "\27[0m")
    else
      print("\27[32m" .. i .. ". " .. file .. "\27[0m")
    end
  end

  local list = io.read()
  local selection = tonumber(list)

  if selection and selection >= 1 and selection <= #files then
    local selectedFile = files[selection]    
    
    if filesystem.isDirectory(selectedFile) then
      os.execute("cd " .. selectedFile .. " && file_manager")
      os.exit()
    end
    
    print("Selected: " .. selectedFile)
    print("1. Rename/Move file")
    print("2. Delete")
    print("3. Run")
    print("4. Edit file")
    print("5. Copy to alternate drive")

    io.write("Select an action: ")
    local action = tonumber(io.read())

    if action == 1 then
        io.write("Enter new name: ")
        local newName = io.read()
        os.execute("mv " .. selectedFile .. " " .. newName)
        print("File renamed.")
    elseif action == 2 then
        os.execute("rm " .. selectedFile)
        print("File deleted.")
    elseif action == 3 then
      if filesystem.isDirectory(selectedFile) then
        os.execute("cd " .. selectedFile)
      else
        os.execute(selectedFile)
      end
    elseif action == 4 then
        os.execute("edit " .. selectedFile)
    elseif action == 5 then
      io.write("please enter in the first 3 characters of the drive id (the long number/letter thing when you hover over the disk in your computer)\n")
      io.write("-> ")
      local drive = io.read()
      print("Copying file to " .. drive .. "...")
      os.execute("copy " .. selectedFile .. " ../mnt/" .. drive)
      io.write("Finished. Press enter to return to file manager.")
      io.read()
      os.execute("file_manager")
    else
        print("hi can you read? this is not an available option.")
    end
  else
    print("hi can you read?")
  end
  print("returning to home")
  os.execute("sh")
  ::continue::
end