term = require("term")
term.clear()
print("Note: You need an internet card to use this program.")
print("1-pastebin")
print("2-github")

io.write("-> ")
local choice = io.read()

if choice == "1" then
  io.write("pastebin code: ")
  local pastebinCode = io.read()
  io.write("file name: ")
  local filename = io.read()
  os.execute("pastebin get " .. pastebinCode .. " " .. filename)
  os.execute(main)  
elseif choice == "2" then
  io.write("raw github link (click raw on the chosen file): ")
  local githubCode = io.read()
  os.execute("wget " .. githubCode)
  os.execute(main)  
else
  print("not a valid option.")
  os.execute("program_installer")
end