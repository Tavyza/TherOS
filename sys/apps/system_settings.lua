local t = require("term")
local ct = require("centerText")
local gpu = require("component").gpu
local e = require("event")
local w, h = gpu.getResolution()

while true do
  t.clear()
  ct(1, "TherOS system settings")
  local settings = {
    "Background Color",
    "App directory",
    "Default text color",
    "File Manager file text color",
    "File Manager directory text color",
    "Main header text",
    "Terminal"
  }

  for i, setting in ipairs(settings) do
    ct(3+(i-1)*2, setting)
  end

  local config = io.open("/sys/thercon", "r")
  local lines = {}
  for line in config:lines() do
    table.insert(lines, line)
  end
  config:close()

  local _, _, _, y, _, _ = e.pull("touch")
  local choice = math.floor((y-3)/2)+1

  if choice == 1 then -- background color
    t.setCursor((w/2)-15, 4)
    local bkgclr = lines[8]
    io.write("background color currently set as: " .. bkgclr .. ". set to: ")
    local newbkgclr = io.read()
    if newbkgclr and newbkgclr ~= "" then
      lines[8] = newbkgclr
    end
    config = io.open("/sys/thercon", "w")
    for _, line in ipairs(lines) do
      config:write(line .. "\n")
    end
    config:close()

  elseif choice == 2 then -- app directory
    t.setCursor((w/2)-15, 6)
    local appdir = lines[12]
    io.write("app directory currently: " .. appdir .. ". set to: ")
    local newappdir = io.read()
    if newappdir and newappdir ~= "" then
      lines[12] = newappdir
    end
    config = io.open("/sys/thercon", "w")
    for _, line in ipairs(lines) do
      config:write(line .. "\n")
    end
    config:close()

  elseif choice == 3 then -- default text color
    t.setCursor((w/2)-15, 8)
    local envtextclr = lines[16]
    io.write("default text color currently: " .. envtextclr .. ". set to: ")
    local newenvtextclr = io.read()
    if newenvtextclr and newenvtextclr ~= "" then
      lines[16] = newenvtextclr
    end
    config = io.open("/sys/thercon", "w")
    for _, line in ipairs(lines) do
      config:write(line .. "\n")
    end
    config:close()

  elseif choice == 4 then -- file manager file text color
    t.setCursor((w/2)-15, 10)
    local fmfiletxtclr = lines[20]
    io.write("file manager file color currently: " .. fmfiletxtclr .. ". set to: ")
    local newfmfiletxtclr = io.read()
    if newfmfiletxtclr and newfmfiletxtclr ~= "" then
      lines[20] = newfmfiletxtclr
    end
    config = io.open("/sys/thercon", "w")
    for _, line in ipairs(lines) do
      config:write(line .. "\n")
    end
    config:close()

  elseif choice == 5 then -- file manager directory text color
    t.setCursor((w/2)-15, 12)
    local fmdirtxtclr = lines[24]
    io.write("file manager directory color currently: " .. fmdirtxtclr .. ". set to: ")
    local newfmdirtxtclr = io.read()
    if newfmdirtxtclr and newfmdirtxtclr ~= "" then
      lines[24] = newfmdirtxtclr
    end
    config = io.open("/sys/thercon", "w")
    for _, line in ipairs(lines) do
      config:write(line .. "\n")
    end
    config:close()

  elseif choice == 6 then -- main env header text
    t.setCursor((w/2)-15, 14)
    local envhdrtxt = lines[28]
    io.write("main env header text currently: " .. envhdrtxt .. ". set to: ")
    local newenvhdrtxt = io.read()
    if newenvhdrtxt and newenvhdrtxt ~= "" then
      lines[28] = newenvhdrtxt
    end
    config = io.open("/sys/thercon", "w")
    for _, line in ipairs(lines) do
      config:write(line .. "\n")
    end
    config:close()

  elseif choice == 7 then -- terminal app
    t.setCursor((w/2)-15, 16)
    local termapp = lines[32]
    io.write("terminal app currently: " .. termapp .. ". set to (full path): ")
    local newtermapp = io.read()
    if newtermapp and newtermapp ~= "" then
      lines[32] = newtermapp
    end
    config = io.open("/sys/thercon", "w")
    for _, line in ipairs(lines) do
      config:write(line .. "\n")
    end
    config:close()
  end
end
