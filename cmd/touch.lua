local arg = ...

io.println(arg)
file = fs.open("/" .. arg, "w")
file:close()