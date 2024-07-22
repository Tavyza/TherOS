local shell = require("shell")

local args, ops = shell.parse(...)
shell.setWorkingDirectory(args[1])
