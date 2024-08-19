-- TherOS system settings

print("loading...")

local fs = require("filesystem")
local th = require("theros")
local conf = require("conlib")
local t = require("term")
local gpu = require("component").gpu

local bkgclr, txtclr, usoclr, sloclr, fmdclr, fmfclr, appdir, trmdir, editor = conf.general()
local sysver, _, _, _, configver = conf.version()
t.clear()
gpu.setBackground(bkgclr)