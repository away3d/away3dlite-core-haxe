package away3dlite.materials;

import flash.display.BitmapData;
import flash.display.IGraphicsData;
import flash.Lib;
import flash.Vector;

/**
 * BitmapMaterial : embed image as texture
 * @author katopz
 */
class BitmapMaterial extends Material
{

	
	public var bitmap(get_bitmap, set_bitmap):BitmapData;
	private inline function get_bitmap():BitmapData
	{
		return _graphicsBitmapFill.bitmapData;
	}
	private function set_bitmap(val:BitmapData):BitmapData
	{
		_graphicsBitmapFill.bitmapData = val;
		return val;
	}
	
		/**
		 * Defines whether repeat is used when drawing the material.

		 */
	public var repeat(get_repeat, set_repeat):Bool;
	private inline function get_repeat():Bool
	{
		return _graphicsBitmapFill.repeat;
	}
	private inline function set_repeat(val:Bool):Bool
	{
		return _graphicsBitmapFill.repeat = val;
	}
	
		/**
		 * Defines whether smoothing is used when drawing the material.

		 */
	public var smooth(get_smooth, set_smooth):Bool;
	private inline function get_smooth():Bool
	{
		return _graphicsBitmapFill.smooth;
	}
	private inline function set_smooth(val:Bool):Bool
	{
		return _graphicsBitmapFill.smooth = val;
	}
	
		/**
		 * Returns the width of the material's bitmapdata object.

		 */
	public var width(get_width, null):Int;
	private inline function get_width():Int
	{
		return _graphicsBitmapFill.bitmapData.width;
	}
		/**
		 * Returns the height of the material's bitmapdata object.
		 */
	public var height(get_height, null):Int;
	private function get_height():Int
	{
		return _graphicsBitmapFill.bitmapData.height;
	}
	
		/**
		 * Creates a new <code>BitmapMaterial</code> object.
		 * 
		 * @param	bitmap		The bitmapData object to be used as the material's texture.
		 */
	public function new(?bitmapData:BitmapData)
	{
		super();
		
		_graphicsBitmapFill.bitmapData = (bitmapData != null) ? bitmapData : new BitmapData(100, 100, false, 0x000000);
		
		graphicsData = new Vector<IGraphicsData>();
		graphicsData = Lib.vectorOfArray([_graphicsStroke, _graphicsBitmapFill, _triangles, _graphicsEndFill]);
		graphicsData.fixed = true;
		
		trianglesIndex = 2;
	}
}