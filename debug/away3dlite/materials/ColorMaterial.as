package away3dlite.materials
{
	import away3dlite.core.utils.*;
	
	import flash.display.*;

	/**
	 * Basic color material.
	 */
	public class ColorMaterial extends Material
	{
		private var _color:uint;
		private var _alpha:Number;
		
		/**
		 * Defines the color of the material. Default value is random.
		 */
		public function get color():uint
		{
			return _color;
		}
		public function set color(val:uint):void
		{
			if (_color == val)
				return;
			
			_color = val;
			
			_graphicsBitmapFill.bitmapData = new BitmapData(2, 2, _alpha < 1, int(_alpha*0xFF) << 24 | _color);
		}
		
		/**
		 * Defines the transparency of the material. Default value is 1.
		 */
		public function get alpha():Number
		{
			return _alpha;
		}
		public function set alpha(val:Number):void
		{
			if (_alpha == val)
				return;
			
			_alpha = val;
			
			_graphicsBitmapFill.bitmapData = new BitmapData(2, 2, _alpha < 1, int(_alpha*0xFF) << 24 | _color);
		}
        
		/**
		 * Creates a new <code>BitmapMaterial</code> object.
		 * 
		 * @param	color		The color of the material.
		 * @param	alpha		The transparency of the material.
		 */
		public function ColorMaterial(color:* = null, alpha:Number = 1)
		{
			super();
			
			_color = Cast.color(color || "random");
			_alpha = alpha;
			
			_graphicsBitmapFill = new GraphicsBitmapFill(new BitmapData(2, 2, _alpha < 1, int(_alpha*0xFF) << 24 | _color));
			
			graphicsData = Vector.<IGraphicsData>([_graphicsStroke, _graphicsBitmapFill, _triangles, _graphicsEndFill]);
			graphicsData.fixed = true;
			
			trianglesIndex = 2;
		}
	}
}