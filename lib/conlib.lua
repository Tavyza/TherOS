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
config.fmfclr = 0x00FF00

-- apps directory (ABSOLUTE PATH ONLY)
config.appdir = "/sys/apps/"

-- terminal location (ABSOLUTE PATH ONLY)
config.trmdir = "/bin/therterm.lua"

-- default editor (ABSOLUTE PATH ONLY)
config.editor = "/bin/edit.lua"

function config.general()
  return config.bkgclr, config.txtclr, config.usoclr, config.sloclr, config.fmdclr, config.fmfclr, config.appdir, config.trmdir, config.editor
end
-- versions for various system utilities, basically in what version they were updated last
config.sysver = "1.1.3-B"
config.inver = "1.1.3-B" -- installer version
config.fmver = "1.1.3-B" -- file manager version
config.ctlibver = "1.1.2-B" -- center text library version
config.configver = "1.1.2-B"
config.theroslibver = "1.1.2-B"
config.termver = "1.1.3-B"

function config.version()
  return config.sysver, config.inver, config.fmver, config.ctlibver, config.configver, config.theroslibver, config.termver
end

return config