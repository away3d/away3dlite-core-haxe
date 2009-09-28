//OK

package away3dlite.materials;
import flash.display.GraphicsBitmapFill;
import flash.display.GraphicsEndFill;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.GraphicsTrianglePath;
import flash.display.IGraphicsData;
import flash.events.EventDispatcher;
import flash.Vector;


/**
 * Base material class.
 */	
class Material extends EventDispatcher
{
	private static var DEBUG_STROKE:GraphicsStroke = new GraphicsStroke(1, false, "normal", "none", "round", 0, new GraphicsSolidFill(0xFF00FF));
	private var _debug:Bool;
	/** @private */
	private var _graphicsStroke:GraphicsStroke;
	/** @private */
	private var _graphicsBitmapFill:GraphicsBitmapFill;
	/** @private */
	private var _graphicsEndFill:GraphicsEndFill;
	/** @private */
	private var _triangles:GraphicsTrianglePath;
	/** @private */
	public var graphicsData:Vector<IGraphicsData>;
	/** @private */
	public var trianglesIndex:Int;
	
	/**
	 * Creates a new <code>Material</code> object.
	 */
	public function new() 
	{
		super();
		
		_debug = false;
		_graphicsStroke = new GraphicsStroke();
		_graphicsBitmapFill = new GraphicsBitmapFill();
		_graphicsEndFill = new GraphicsEndFill();
	}
	
	/**
	 * Switches on the debug outlines around each face drawn with the material. Defaults to false.
	 */
	public var debug(get_debug, set_debug):Bool;
	private function get_debug():Bool
	{
		return _debug;
	}
	private function set_debug(val:Bool):Bool
	{
		if (_debug == val)
			return val;
			
		_debug = val;
		
		graphicsData.fixed = false;
		
		if(_debug) {
			graphicsData.shift();
			graphicsData.unshift(DEBUG_STROKE);
		} else {
			graphicsData.shift();
			graphicsData.unshift(_graphicsStroke);
		}
		
		graphicsData.fixed = true;
		return val;
	}
}