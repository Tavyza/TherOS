-- config for TherOS
local config = {}
--[[
============================================
|                GENERAL                   |
============================================
]] 
config.bkgclr = 0x000028

config.txtclr = 0xFFFFFF

-- unselected option color (for apps that support it and main env)
config.usoclr = 0x282828

-- selected option color (for apps that support it and main env)
config.sloclr = 0xFFFFFF

-- file manager dir color
config.fmdclr = 0x0000FF

-- file manager file color
config.fmfclr = 0x59760e

-- apps directory (ABSOLUTE PATH ONLY)
config.appdir = "/home/apps/"

-- terminal location (ABSOLUTE PATH ONLY)
config.trmdir = "/bin/therterm.lua"

-- default editor (ABSOLUTE PATH ONLY)
config.editor = "/bin/edit.lua"

function config.general()
  return config.bkgclr, config.txtclr, config.usoclr, config.sloclr, config.fmdclr, config.fmfclr, config.appdir, config.trmdir, config.editor
end

config.sysver = "2.0.1-B"
config.updaterver = "2.0.1-B"
config.fmver = "2.0.1-B"
config.ctlibver = "2.0.0-B"
config.configver = "2.0.1-B"
config.winlibver = "2.0.1-B"
config.termver = "2.0.1-B"

function config.version()
  return config.sysver, config.updaterver, config.fmver, config.ctlibver, config.configver, config.winlibver, config.termver
end

return config