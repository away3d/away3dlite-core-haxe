/**
 * Math utils for very fast math operations.
 */

package away3dlite.haxeutils;

class MathUtils 
{
	public static inline var PI:Float = 3.141592653589793;
	public static inline var HALF_PI:Float = PI / 2 ;
	public static inline var TWO_PI:Float = PI * 2 ;
	
	
	public static inline var NEGATIVE_INFINITY = Math.NEGATIVE_INFINITY;
	public static inline var POSITIVE_INFINITY = Math.POSITIVE_INFINITY;
	
	public static inline var toRADIANS:Float = PI / 180;
	public static inline var toDEGREES:Float = 180 / PI;
	
	public static inline var B = 4 / PI;
	public static inline var C = -4 / (PI*PI);
	public static inline var P = 0.225;
	
	
}