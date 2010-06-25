package nme.filters;

package jsflash.filters;

#if flash
typedef BitmapFilterQuality = flash.filters.BitmapFilterQuality;
#else true
typedef BitmapFilterQuality = nme.filters.BitmapFilterQuality;
#end

