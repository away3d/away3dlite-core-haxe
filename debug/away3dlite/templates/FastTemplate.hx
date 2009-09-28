package away3dlite.templates;
import away3dlite.core.clip.Clipping;
import away3dlite.core.render.FastRenderer;


/**
 * Fast Template
 * @author katopz
 */
class FastTemplate extends Template
{
	private override function init():Void
	{
		super.init();
		
		view.renderer = renderer;
		view.clipping = clipping;
	}
	
	public function new()
	{
		renderer = new FastRenderer();
		clipping = new Clipping();
		super();
	}
	public var renderer:FastRenderer;
	
	/**
	 * The clipping object used in the template.
	 */
	public var clipping:Clipping;
}