package away3dlite.materials
{
	import flash.display.*;
	
    /**
     * Basic bitmap material
     */
	public class BitmapMaterial extends Material
	{
		/**
		 * Defines the bitmapData object to be used as the material's texture.
		 */
		public function get bitmap():BitmapData
		{
			return _graphicsBitmapFill.bitmapData;
		}
		
		public function set bitmap(val:BitmapData):void
		{
			_graphicsBitmapFill.bitmapData = val;
		}
		
		/**
		 * Defines whether repeat is used when drawing the material.
		 */
		public function get repeat():Boolean
		{
			return _graphicsBitmapFill.repeat;
		}
		
		public function set repeat(val:Boolean):void
		{
			_graphicsBitmapFill.repeat = val;
		}
		
		/**
		 * Defines whether smoothing is used when drawing the material.
		 */
		public function get smooth():Boolean
		{
			return _graphicsBitmapFill.smooth;
		}
		
		public function set smooth(val:Boolean):void
		{
			_graphicsBitmapFill.smooth = val;
		}
		
		/**
		 * Returns the width of the material's bitmapdata object.
		 */
		public function get width():int
		{
			return _graphicsBitmapFill.bitmapData.width;
		}
		
		/**
		 * Returns the height of the material's bitmapdata object.
		 */
		public function get height():int
		{
			return _graphicsBitmapFill.bitmapData.height;
		}
        
		/**
		 * Creates a new <code>BitmapMaterial</code> object.
		 * 
		 * @param	bitmap		The bitmapData object to be used as the material's texture.
		 */
		public function BitmapMaterial(bitmap:BitmapData = null)
		{
			super();
			
			_graphicsBitmapFill.bitmapData = bitmap || new BitmapData(100, 100, false, 0x000000);
			
			graphicsData = Vector.<IGraphicsData>([_graphicsStroke, _graphicsBitmapFill, _triangles, _graphicsEndFill]);
			graphicsData.fixed = true;
			
			trianglesIndex = 2;
		}
	}
}