package jsflash.filters;

#if !js
typedef BlurFilter = nme.filters.BlurFilter;
#else
typedef BlurFilter = canvas.filters.BlurFilter;
#end

