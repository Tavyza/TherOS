term = require("term")
term.clear()
print("Command prompt. All OpenOS commands should work here. This exists to allow you to do things by yourself.\n Warning-This program may be unstable and may not work as intended.")
print("enter in 'exit' to close the command prompt.")

while true do
  io.write("-> ")
  local command = io.read()
  if command == "exit" then
    break
  end
  os.execute(command)
end

print("exiting command prompt")
os.execute("sh")