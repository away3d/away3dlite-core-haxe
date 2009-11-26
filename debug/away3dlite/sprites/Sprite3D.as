package away3dlite.sprites
{
	import away3dlite.arcane;
	import away3dlite.materials.*;
	
	import flash.geom.*;
	
	use namespace arcane;
	
	/**
	 * Single billboard object (one that always faces the camera).
	 * Draws 2d objects inline with z-sorted triangles in a scene.
	 */
	public class Sprite3D
	{
        /** @private */
        arcane var index:int;
        /** @private */
		arcane var indices:Vector.<int> = new Vector.<int>();
		/** @private */
		arcane var uvtData:Vector.<Number> = new Vector.<Number>();
		
		private var _scale:Number = 1;
		private var _width:Number;
    	private var _height:Number;
		private var _vertices:Vector.<Number> = new Vector.<Number>();
		private var _verticesDirty:Boolean;
		private var _material:Material;
		private var _position:Vector3D = new Vector3D();
		
		protected function updateVertices():void
     	{
			_verticesDirty = false;
			
			_vertices.fixed = false;
			_vertices.length = 0;
			_vertices.push(-_width*_scale/2, -_height*_scale/2, 0);
			_vertices.push(-_width*_scale/2, _height*_scale/2, 0);
			_vertices.push(_width*_scale/2, _height*_scale/2, 0);
			_vertices.push(_width*_scale/2, -_height*_scale/2, 0);
			_vertices.fixed = true;
		}

    	/**
    	 * Defines the x position of the Sprite3D object. Defaults to 0.
    	 */
    	public var x:Number = 0;
    	
    	/**
    	 * Defines the y position of the Sprite3D object. Defaults to 0.
    	 */
    	public var y:Number = 0;
    	
    	/**
    	 * Defines the z position of the Sprite3D object. Defaults to 0.
    	 */
    	public var z:Number = 0;
    	
    	/**
    	 * Defines the way the sprite aligns its plane to face the viewer. Allowed values are "viewplane" or "viewpoint". Defaults to "viewplane".
    	 * 
    	 * @see away3dlite.sprites.AlignmentType
    	 */
    	public var alignmentType:String;
    	
    	/**
    	 * Defines the overall scale of the Sprite3D object. Defaults to 1.
    	 */
    	public function get scale():Number
    	{
    		return _scale;
    	}
    	
    	public function set scale(val:Number):void
    	{
    		if (_scale == val)
    			return;
    		
    		_scale = val;
    		_verticesDirty = true;
    	}
		
    	/**
    	 * Defines the width of the Sprite3D object. Defaults to the material width if BitmapMaterial, otherwise 100.
    	 */
    	public function get width():Number
    	{
    		if (isNaN(_width))
    			return 100;
    		
    		return _width;
    	}
    	
    	public function set width(val:Number):void
    	{
    		if (_width == val)
    			return;
    		
    		_width = val;
    		_verticesDirty = true;
    	}
		
    	/**
    	 * Defines the height of the Sprite3D object. Defaults to the material height if BitmapMaterial, otherwise 100.
    	 */
    	public function get height():Number
    	{
    		if (isNaN(_height))
    			return 100;
    		
    		return _height;
    	}
    	
    	public function set height(val:Number):void
    	{
    		if (_height == val)
    			return;
    		
    		_height = val;
    		_verticesDirty = true;
    	}
    	
		/**
		 * @inheritDoc
		 */
        public function get vertices():Vector.<Number>
        {
    		if (_verticesDirty)
    			updateVertices();
    		
            return _vertices;
        }
		
		/**
		 * Determines the material used on the sprite.
		 */
		public function get material():Material
		{
			return _material;
		}
		public function set material(val:Material):void
		{
			val = val || new WireColorMaterial();
			
			if (_material == val)
				return;
			
			_material = val;
			
			if (_material is BitmapMaterial) {
				var bitmapMaterial:BitmapMaterial = _material as BitmapMaterial;
				
				if (isNaN(_width))
					width = bitmapMaterial.width;
				if (isNaN(_height))
					height = bitmapMaterial.height;
			}
		}
		
		/**
		 * Returns a 3d vector representing the local position of the 3d sprite.
		 */
		public function get position():Vector3D
		{
			_position.x = x;
			_position.y = y;
			_position.z = z;
			
			return _position;
		}
		
		/**
		 * Creates a new <code>Sprite3D</code> object.
		 * 
		 * @param material		Determines the material used on the faces in the <code>Sprite3D</code> object.
		 */
		public function Sprite3D(material:Material = null, scale:Number = 1)
		{
			super();
			
			this.material = material;
			this.scale = scale;
			this.alignmentType = AlignmentType.VIEWPLANE;
			
			//create indices for sprite
			indices.push(0, 1, 2, 3);
			
			//create uvtData for sprite
			uvtData.push(0, 0, 0);
			uvtData.push(0, 1, 0);
			uvtData.push(1, 1, 0);
			uvtData.push(1, 0, 0);
			
			//create faces
			updateVertices();
		}

		
		/**
		 * Duplicates the sprite3d properties to another <code>Sprite3D</code> object.
		 * 
		 * @param	object	[optional]	The new object instance into which all properties are copied. The default is <code>Sprite3D</code>.
		 * @return						The new object instance with duplicated properties applied.
		 */
        public function clone(object:Sprite3D = null):Sprite3D
        {
            var sprite3D:Sprite3D = (object as Sprite3D) || new Sprite3D();
            sprite3D.x = x;
            sprite3D.y = y;
            sprite3D.z = z;
            sprite3D.scale = scale;
            sprite3D.width = _width;
            sprite3D.height = _height;
            sprite3D.material = material;
            
            return sprite3D;
        }
	}
}
