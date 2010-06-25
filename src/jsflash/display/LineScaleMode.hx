package jsflash.display;

#if (neko||cpp)
typedef LineScaleMode = nme.display.LineScaleMode;
#elseif flash
typedef LineScaleMode = flash.display.LineScaleMode;
#else
typedef LineScaleMode = canvas.display.LineScaleMode;
#end

