-- system utilities
local util = {}
gpu = kernel.primary_gpu
w, h = gpu.getResolution()

-- copied directly from openOS
util.window = 
{
  fullscreen = true,
  blink = true,
  dx = 0,
  dy = 0,
  x = 1,
  y = 1,
  output_buffer = "",
}

function util.clear()
  gpu.fill(1, 1, w, h, " ")
end