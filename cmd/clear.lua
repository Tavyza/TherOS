gpu = kernel.primary_gpu

local w, h = gpu.getResolution()
gpu.fill(1, 1, w, h, " ")