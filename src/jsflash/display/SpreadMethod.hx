package jsflash.display;

#if (neko||cpp)
typedef SpreadMethod = nme.display.SpreadMethod;
#else
typedef SpreadMethod = canvas.display.SpreadMethod;
#end
