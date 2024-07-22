-- config for TherOS
local config = {}
--[[
============================================
|                GENERAL                   |
============================================
]] 
config.bkgclr = 0x000028

config.txtclr = 0xFFFFFF

-- unselected option color (for apps that support it)
config.usoclr = 0x282828

-- selected option color (for apps that support it)
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
-- versions for various system utilities, basically in what version they were updated last
config.sysver = "1.1.2-B"
config.updaterver = "1.1.2-B"
config.fmver = "1.1.2-B"
config.ctlibver = "1.1.2-B"
config.configver = "1.1.2-B"
config.theroslibver = "1.1.2-B"
config.termver = "1.1.2-B"

function config.version()
  return config.sysver, config.updaterver, config.fmver, config.ctlibver, config.configver, config.theroslibver, config.termver
end

return config