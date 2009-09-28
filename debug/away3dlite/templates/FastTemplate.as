package away3dlite.templates
{
	import away3dlite.arcane;
	import away3dlite.core.clip.*;
	import away3dlite.core.render.*;

	use namespace arcane;
	
	/**
	 * Template setup designed for speed.
	 */
	public class FastTemplate extends Template
	{
		/** @private */
		arcane override function init():void
		{
			super.init();
			
			view.renderer = renderer;
			view.clipping = clipping;
			view.mouseEnabled = false;
		}
		
		/**
		 * The renderer object used in the template.
		 */
		public var renderer:FastRenderer = new FastRenderer();
		
		/**
		 * The clipping object used in the template.
		 */
		public var clipping:Clipping = new Clipping();
	}
}