package away3dlite.templates
{
	import away3dlite.arcane;
	import away3dlite.core.clip.*;
	import away3dlite.core.render.*;

	use namespace arcane;
	
	/**
	 * Template setup designed for general use.
	 */
	public class BasicTemplate extends Template
	{
		/** @private */
		arcane override function init():void
		{
			super.init();
			
			view.renderer = renderer;
			view.clipping = clipping;
		}
		
		/**
		 * The renderer object used in the template.
		 */
		public var renderer:BasicRenderer = new BasicRenderer();
		
		/**
		 * The clipping object used in the template.
		 */
		public var clipping:RectangleClipping = new RectangleClipping();
	}
}