function thercon()
  configlines = {}
  local config = require("term").open("/sys/thercon", "r")
  if config == "" then
    require("component").gpu.setForeground(0xFF0000)
    io.write("Critical error! Config file not found. Please pull it from github and put it at /sys/thercon or re-install.")
  end
  for line in config:lines() do
    table.insert(configlines, line)
  end
  config:close()

  backgroundcolor = configlines[8]
  appdir = configlines[12]
  envtextcolor = configlines[15]
  fmfiletextcolor = configlines[19]
  fmdirtextcolor = configlines[24]
  envtitletext = configlines[28]
  terminal = configlines[32]
end

return backgroundcolor, appdir, envtextcolor, fmfiletextcolor, fmdirtextcolor, envtitletext, terminal