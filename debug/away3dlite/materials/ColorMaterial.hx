package away3dlite.materials;
import away3dlite.core.utils.Cast;
import away3dlite.haxeutils.FastStd;
import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;
import flash.display.IGraphicsData;
import flash.Lib;
import flash.Vector;


/**
 * ColorMaterial
 * @author katopz
 */
class ColorMaterial extends Material
{
	
	/**
	 * Defines the color of the material. Default value is random.

	 */
	private var _color:UInt;
	public var color(get_color, set_color):UInt;
	private inline function get_color():UInt
	{
		return _color;
	}
	private function set_color(val:UInt):UInt
	{
		if (_color == val)
			return val;
		
		_color = val;
		
		_graphicsBitmapFill.bitmapData = new BitmapData(2, 2, _alpha < 1, Std.int(_alpha * 0xFF) << 24 | _color);
		return val;
	}
	
	/**
	 * Defines the transparency of the material. Default value is 1.

	 */
	private var _alpha:Float;
	public var alpha(get_alpha, set_alpha):Float;
	private inline function get_alpha():Float
	{
		return _alpha;
	}
	private function set_alpha(val:Float):Float
	{
		if (_alpha == val)
			return val;
		
		_alpha = val;
		
		_graphicsBitmapFill.bitmapData = new BitmapData(2, 2, _alpha < 1, Std.int(_alpha * 0xFF) << 24 | _color);
		return val;
	}
	
	/**
	 * Creates a new <code>BitmapMaterial</code> object.
	 * 
	 * @param	color		The color of the material.
	 * @param	alpha		The transparency of the material.
	 */
	public function new(?color:Dynamic, ?alpha:Float = 1.0)
	{
		super();

		this._color = (color != null) ? Cast.color(color) : Cast.color("random");
		this._alpha = alpha;
		
		_graphicsBitmapFill = new GraphicsBitmapFill(new BitmapData(2, 2, _alpha < 1, Std.int(_alpha*0xFF) << 24 | _color));
		
		graphicsData = new Vector<IGraphicsData>();
		graphicsData = Lib.vectorOfArray([_graphicsStroke, _graphicsBitmapFill, _triangles, _graphicsEndFill]);
		graphicsData.fixed = true;
		
		trianglesIndex = 2;
	}
}