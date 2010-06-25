package jsflash.display;

#if (neko||cpp)
typedef CapsStyle = nme.display.CapsStyle;
#else
typedef CapsStyle = canvas.display.CapsStyle;
#end

