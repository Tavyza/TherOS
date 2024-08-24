-- conlib for TherOS
conlib = {}
configfile = io.open("/sys/.config/general.tc", "r")
fullfile = configfile:read("*a")
configfile:close()
general = {}
for line in fullfile:gmatch("[^\r\n]+") do
  table.insert(general, line)
end
for _, line in ipairs(general) do
  conlib.bkgclr = conlib.bkgclr or tonumber(line:match("Bck%-clr:%s*(.+)"))
  conlib.txtclr = conlib.txtclr or tonumber(line:match("Txt%-clr:%s*(.+)"))
  conlib.usoclr = conlib.usoclr or tonumber(line:match("Usl%-clr:%s*(.+)"))
  conlib.sloclr = conlib.sloclr or tonumber(line:match("Sel%-clr:%s*(.+)"))
  conlib.fmdclr = conlib.fmdclr or tonumber(line:match("Fmd%-clr:%s*(.+)"))
  conlib.fmfclr = conlib.fmfclr or tonumber(line:match("Fmf%-clr:%s*(.+)"))
  conlib.appdir = conlib.appdir or line:match("App%-dir:%s*(.+)")
  conlib.trmdir = conlib.trmdir or line:match("Trm%-dir:%s*(.+)")
  conlib.editor = conlib.editor or line:match("Edt%-dir:%s*(.+)")
end

function conlib.general()
  return conlib.bkgclr, conlib.txtclr, conlib.usoclr, conlib.sloclr, conlib.fmdclr, conlib.fmfclr, conlib.appdir, conlib.trmdir, conlib.editor
end
configfile = io.open("/sys/.config/version.tc")
fullfile = configfile:read("*a")
configfile:close()
version = {}
for line in fullfile:gmatch("[^\r\n]+") do
  table.insert(version, line)
end

for _, line in ipairs(version) do
  conlib.sysver = conlib.sysver or line:match("System:%s*(.+)")
  conlib.inver = conlib.inver or line:match("Instll:%s*(.+)")
  conlib.fmver = conlib.fmver or line:match("Filemn:%s*(.+)")
  conlib.ctlibver = conlib.ctlibver or line:match("Ctxlib:%s*(.+)")
  conlib.configver = conlib.configver or line:match("Config:%s*(.+)")
  conlib.theroslibver = conlib.theroslibver or line:match("ThOlib:%s*(.+)")
  conlib.termver = conlib.termver or line:match("Termin:%s*(.+)")
end

function conlib.version()
  return conlib.sysver, conlib.inver, conlib.fmver, conlib.ctlibver, conlib.configver, conlib.theroslibver, conlib.termver
end

return conlib

