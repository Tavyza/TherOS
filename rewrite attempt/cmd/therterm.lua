-- TherOS terminal app
require("conlib")
local t = require("term")
local th = require("theros")
local conf = require("conlib")
local fs = require("filesystem")
local shell = require("shell")
local sysver, _, _, _, _, _, termver = conf.version()

local pwd = os.getenv("PWD")

print("THEROS VERSION: " .. sysver)
print("TERMINAL VERSION: " .. termver)
print("-------------------------------")
print("Type \"help\" for a list of commands.")

while true do
  io.write(pwd .. " -> ")
  command = io.read()
  if command == "exit" then
    break
  end
  shell.execute(command)
end