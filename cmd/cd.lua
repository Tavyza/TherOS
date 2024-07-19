local shell = require("shell")
local t = require("term")

local args, ops = shell.parse(...)
t.setWorkingDirectory(args[1])
