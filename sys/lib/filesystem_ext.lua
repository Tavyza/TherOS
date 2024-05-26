local fs = require("filesystem")

function copyDir(srcDir, destDir)
  for file in fs.list(srcDir) do
    local srcPath = fs.concat(srcDir, file)
    local destPath = fs.concat(destDir, file)
    if not fs.isDirectory(srcPath) then
      fs.copy(srcPath, destPath)
    else
      fs.makeDirectory(destPath)
      copyDir(srcPath, destPath)
    end
  end
end

return {
  copyDir = copyDir
}
