term = require("term")
term.clear()
print("TherTerm 1.0.0")
print("For help, type help\nTo exit, type exit")

while true do
  io.write("-> ")
  local command = io.read()
  if command == "exit" then
    break
  elseif command == "help" then
    print("-- HELP --")
    print("Commands: \nhelp - Shows this menu\nexit - closes the command prompt")
    print("-- HELP --")
  else
    os.execute(command)
  end
end

print("exiting command prompt")
os.execute("sh")
