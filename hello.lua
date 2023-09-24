-- text adventure
term = require("term")
term.clear()

print("Welcome to the TherOS text adventure. Created on day 3873. Goal: Dont die")
print("You exist. Continue?")
io.write("yes/no -> ")
local a1 = io.read()
if a1 == "yes" then
  ::gamer::
  io.write("You are going down a road, and come to a fork.\n Left or right? ->")
  local a2 = io.read()
  if a2 == "right" then
    -- town
  elseif a2 == "left" then
    -- town't
  else
    goto gamer
  end
else
  os.execute("sh")
end