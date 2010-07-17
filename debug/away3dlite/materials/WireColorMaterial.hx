package away3dlite.materials;
import away3dlite.core.utils.Cast;
import flash.display.GraphicsSolidFill;
import flash.Lib;

using away3dlite.haxeutils.HaxeUtils;

/**
 * ColorMaterial
 * @author katopz
 */
class WireColorMaterial extends ColorMaterial
{
	
	/**

	 * Defines the color of the outline.
	 */
	private var _wireColor:UInt;
	public var wireColor(get_wireColor, set_wireColor):UInt;
	private inline function get_wireColor():UInt
	{
		return _wireColor;
	}
	private function set_wireColor(val:UInt):UInt
	{
		if (_wireColor == val)
			return val;
		
		_wireColor = val;
		
		_graphicsStroke.fill.downcast(GraphicsSolidFill).color = _wireColor;
		return val;
	}
	
	/**

	 * Defines the transparency of the outline.
	 */
	private var _wireAlpha:Float;
	public var wireAlpha(get_wireAlpha, set_wireAlpha):Float;
	private inline function get_wireAlpha():Float
	{
		return _wireAlpha;
	}
	private function set_wireAlpha(val:Float):Float
	{
		if (_wireAlpha == val)
			return val;
		
		_wireAlpha = val;
		
		_graphicsStroke.fill.downcast(GraphicsSolidFill).alpha = _wireAlpha;
		return val;
	}
	
	/**

	 * Defines the thickness of the outline.
	 */
	private var _thickness:Float;
	public var thickness(get_thickness, set_thickness):Float;
	private inline function get_thickness():Float
	{
		return _thickness;
	}
	private function set_thickness(val:Float):Float
	{
		if (_thickness == val)
			return val;
		
		_thickness = val;
		
		_graphicsStroke.thickness = _thickness;
		return val;
	}
	
	/**
	 * Creates a new <code>WireColorMaterial</code> object.
	 * 
	 * @param	color		The color of the material.
	 * @param	alpha		The transparency of the material.
	 * @param	wireColor	The color of the outline.
	 * @param	wireAlpha	The transparency of the outline.
	 * @param	thickness	The thickness of the outline.
	 */
	public function new(?color:Dynamic, ?alpha:Float = 1.0, ?wireColor:Dynamic, ?wireAlpha:Float = 1.0, ?thickness:Float = 1.0)
	{
		super(color, alpha);
		
		this._wireColor = (wireColor != null) ? Cast.color(wireColor) : 0x000000;
		this._wireAlpha = wireAlpha;
		
		this._thickness = thickness;
		
		_graphicsStroke.fill = new GraphicsSolidFill(_wireColor, _wireAlpha);
		_graphicsStroke.thickness = _thickness;
	}
}