term = require("term")
local filesystem = require("filesystem")

-- Create a function to update the options table
local function updateOptions()
    local luaFiles = {}  -- Table to store Lua file names

    -- Scan the directory for Lua files
    for file in filesystem.list("/home/bin") do
        if file:sub(-4) == ".lua" and file ~= "main.lua" then
            table.insert(luaFiles, file)
        end
    end

    return luaFiles
end

local options = {}

term.clear()
io.write("TherOS 0.1.3. Please select a program by typing the number for it.\n")
io.write("Exit this page by doing ctrl+alt+c\n")
io.write("View changelog in the file manager (edit it to view it)\n")
io.write("-----------------------------------------------------------------------------------\n")

local luaFiles = updateOptions()

for i = #luaFiles, 1 do
    table.insert(options, luaFiles[i])
end

-- Re-add "reboot" and "shutdown" options to the options table
table.insert(options, "reboot")
table.insert(options, "shutdown")

for i, option in ipairs(luaFiles) do
    table.insert(options, option:sub(1, -5)) -- Removing the ".lua" extension
end

for i, option in ipairs(options) do
    io.write(i .. ". " .. option .. "\n")
end
io.write("-> ")
local test = io.read()
local choice = tonumber(test)

if options[choice] then
    io.write(options[choice])
    os.execute(options[choice])
else
    print("Invalid choice.")
end