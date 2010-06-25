package away3dlite.templates;
import away3dlite.core.clip.RectangleClipping;
import away3dlite.core.render.BasicRenderer;

/**
 * SimpleView
 * @author katopz
 */
class BasicTemplate extends Template
{
	private override function init():Void
	{
		super.init();
		
		view.renderer = renderer;
		view.clipping = clipping;
	}
	
	public function new()
	{
		super();
		renderer = new BasicRenderer();
		clipping = new RectangleClipping();
	}
	
	public var renderer:BasicRenderer;
	
	public var clipping:RectangleClipping;
}