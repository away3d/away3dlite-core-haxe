package away3dlite.materials
{
	import away3dlite.core.utils.*;
	
	import flash.display.*;

	/**
	 * Color material with an outline.
	 */
	public class WireColorMaterial extends ColorMaterial
	{
		private var _wireColor:uint;
		private var _wireAlpha:Number;
		private var _thickness:Number;
		
		/**
		 * Defines the color of the outline.
		 */
		public function get wireColor():uint
		{
			return _wireColor;
		}
		public function set wireColor(val:uint):void
		{
			if (_wireColor == val)
				return;
			
			_wireColor = val;
			
			(_graphicsStroke.fill as GraphicsSolidFill).color = _wireColor;
		}
		
		/**
		 * Defines the transparency of the outline.
		 */
		public function get wireAlpha():Number
		{
			return _wireAlpha;
		}
		
		public function set wireAlpha(val:Number):void
		{
			if (_wireAlpha == val)
				return;
			
			_wireAlpha = val;
			
			(_graphicsStroke.fill as GraphicsSolidFill).alpha = _wireAlpha;
		}
		
		/**
		 * Defines the thickness of the outline.
		 */
		public function get thickness():Number
		{
			return _thickness;
		}
		public function set thickness(val:Number):void
		{
			if (_thickness == val)
				return;
			
			_thickness = val;
			
			_graphicsStroke.thickness = _thickness;
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
		public function WireColorMaterial(color:* = null, alpha:Number = 1, wireColor:* = null, wireAlpha:Number = 1, thickness:Number = 1)
		{
			super(color, alpha);
			
			_wireColor = Cast.color(wireColor || 0x000000);
			_wireAlpha = wireAlpha;
			
			_thickness = thickness;
			
			_graphicsStroke.fill = new GraphicsSolidFill(_wireColor, _wireAlpha);
			_graphicsStroke.thickness = _thickness;
		}
	}
}