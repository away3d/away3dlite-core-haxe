package away3dlite.materials
{
	import flash.display.*;

	/**
	 * Outline material.
	 */
	public class WireframeMaterial extends Material
	{
		private var _color:uint;
		private var _alpha:Number;
		
		/**
		 * Defines the color of the outline.
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
			
			_graphicsStroke.fill = new GraphicsSolidFill(_color);
		}
		
		/**
		 * Defines the transparency of the outline.
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
		}
        
		/**
		 * Creates a new <code>WireframeMaterial</code> object.
		 * 
		 * @param	color		The color of the outline.
		 * @param	alpha		The transparency of the outline.
		 */
		public function WireframeMaterial(color:int = 0xFFFFFF, alpha:Number = 1)
		{
			super();
			
			_color = color;
			_alpha = alpha;
			
			_graphicsStroke.fill = new GraphicsSolidFill(_color);
			_graphicsStroke.thickness = 1;
			
			graphicsData = Vector.<IGraphicsData>([_graphicsStroke, _triangles]);
			graphicsData.fixed = true;
			
			trianglesIndex = 1;
		}
	}
}