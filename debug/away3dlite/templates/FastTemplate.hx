package away3dlite.templates;
import away3dlite.core.clip.Clipping;
import away3dlite.core.render.FastRenderer;


/**
 * Template setup designed for speed.
 */
class FastTemplate extends Template
{
	private override function init():Void
	{
		super.init();
		
		view.renderer = renderer;
		view.clipping = clipping;
		view.mouseEnabled3D = false;
	}
	
	public function new()
	{
		renderer = new FastRenderer();
		clipping = new Clipping();
		super();
	}
	
	/**
	 * The renderer object used in the template.
	 */
	public var renderer:FastRenderer;
	
	/**
	 * The clipping object used in the template.
	 */
	public var clipping:Clipping;
}