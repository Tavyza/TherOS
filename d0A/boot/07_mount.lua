local drives = {}

for drive in require("component").list("filesystem") do
  table.insert(drives, drive)
end

for i, drive in ipairs(drives) do
  require("filesystem").mount(drive, "/d" .. i .. "A/")
end