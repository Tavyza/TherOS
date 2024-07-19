-- Neofetch-like command built for TherOS
require("conlib")
local comp = require("computer")
local sysver = version()
local gpu = require("component").gpu
w, h = gpu.getResolution()
print("OS: " .. sysver)
print("Terminal: " .. "placeholder")
print("CPU: " .. "placeholder")
print("GPU: " .. "placeholder")
print("Resolution: " .. w .. ", " .. h)
print("Uptime: " .. comp.uptime())
print("Memory: " .. comp.freeMemory() - comp.totalMemory() .. " b /" .. comp.totalMemory() .. " b")

