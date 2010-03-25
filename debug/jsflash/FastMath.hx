/**
 * ...
 * @author waneck
 */

package jsflash;

class FastMath 
{

	public static inline function abs(x:Float):Float
	{
		return (x < 0) ? -x : x;
	}
	
	public static inline var PI:Float = 3.141592653589793;
	public static inline var HALF_PI:Float = PI / 2 ;
	public static inline var TWO_PI:Float = PI * 2 ;
	
	public static inline var toRADIANS:Float = PI / 180;
	public static inline var toDEGREES:Float = 180 / PI;
	
}