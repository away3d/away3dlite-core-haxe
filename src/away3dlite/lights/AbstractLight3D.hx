package away3dlite.lights;
import away3dlite.cameras.Camera3D;


//use namespace arcane;
using away3dlite.namespace.Arcane;

/**
 * @author robbateman
 */
class AbstractLight3D
{
	private var _color:UInt;
	/** @private */
	/*arcane*/ private var _red:Float;
	/** @private */
	/*arcane*/ private var _green:Float;
	/** @private */
	/*arcane*/ private var _blue:Float;
	/** @private */
	/*arcane*/ private var _camera:Camera3D;
	
	/**
	 * 
	 */
	public var color(get_color, set_color):UInt;
	private function get_color():UInt
	{
		return _color;
	}
	
	private function set_color(val:UInt):UInt
	{
		if (_color == val)
			return val;
		
		_color = val;
		
		_red = ((_color & 0xFF0000) >> 16)/255;
		_green = ((_color & 0xFF00) >> 8)/255;
		_blue  = (_color & 0xFF) / 255;
		return val;
	}
	
	/**
	 * 
	 */
	private function new()
	{
		
	}
}