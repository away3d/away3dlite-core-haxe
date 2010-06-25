package away3dlite.materials;
#if flash9
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;

#end
import flash.Lib;
import flash.Vector;


/**
 * Outline material.


 */
class WireframeMaterial extends Material
{
	private var _color:UInt;
	private var _alpha:Float;
	
	/**
	 * Defines the color of the outline.

	 */
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
		
		#if flash9
		Lib.as(_graphicsStroke.fill, GraphicsSolidFill).color = _color;
		
		#end
		return val;
	}
	
	/**
	 * Defines the transparency of the outline.

	 */
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
		
		#if flash9
		Lib.as(_graphicsStroke.fill, GraphicsSolidFill).alpha = _alpha;
		
		#end
		return val;
	}
	
	/**
	 * Creates a new <code>WireframeMaterial</code> object.
	 * 
	 * @param	color		The color of the outline.
	 * @param	alpha		The transparency of the outline.
	 */
	public function new(?color:Int = 0xFFFFFF, ?alpha:Float = 1.0)
	{
		super();
		
		_color = color;
		_alpha = alpha;
		
		#if flash9
		_graphicsStroke.fill = new GraphicsSolidFill(_color, _alpha);
		_graphicsStroke.thickness = 1;
		
		graphicsData = new Vector<IGraphicsData>();
		graphicsData = Lib.vectorOfArray([_graphicsStroke, _triangles]);
		graphicsData.fixed = true;
		
		trianglesIndex = 1;
		
		#end
	}
}