package away3dlite.primitives
{
	import away3dlite.arcane;
	import away3dlite.core.base.*;
	import away3dlite.materials.*;
    
	use namespace arcane;
	
    /**
    * Creates a 3d cone primitive.
    */ 
    public class Cone extends AbstractPrimitive
    {
        private var jMin:int;
        private var _radius:Number = 100;
        private var _height:Number = 200;
        private var _segmentsW:int = 8;
        private var _segmentsH:int = 1;
        private var _openEnded:Boolean = false;
        private var _yUp:Boolean = true;
        
		/**
		 * @inheritDoc
		 */
    	protected override function buildPrimitive():void
    	{
    		super.buildPrimitive();
			
            var i:int;
            var j:int;
			
            _height /= 2;
			
			if (!_openEnded) {
				jMin = 1;
	            _segmentsH += 1;
	            
	            for (i = 0; i <= _segmentsW; ++i) {
	                _yUp? _vertices.push(0, _height, 0) : _vertices.push(0, 0, -_height);
	            	_uvtData.push(i/_segmentsW, 1, 1);
	            }
			} else {
				jMin = 0;
			}
			
            for (j = jMin; j < _segmentsH; ++j) { 
                var z:Number = -_height + 2*_height*(j - jMin)/(_segmentsH - jMin);
                
                for (i = 0; i <= _segmentsW; ++i) { 
                    var verangle:Number = 2*Math.PI*i/_segmentsW;
                    var ringradius:Number = _radius*(_segmentsH - j)/(_segmentsH - jMin);
                    var x:Number = ringradius*Math.cos(verangle);
                    var y:Number = ringradius*Math.sin(verangle);
                    
                    _yUp? _vertices.push(x, -z, y) : _vertices.push(x, y, z);
                    
                    _uvtData.push(i/_segmentsW, 1 - j/_segmentsH, 1);
                }
            }
            
            for (i = 0; i <= _segmentsW; ++i) {
                _yUp? _vertices.push(0, -_height, 0) : _vertices.push(0, 0, _height);
            	_uvtData.push(i/_segmentsW, 0, 1);
            }
			
            for (j = 1; j <= _segmentsH; ++j) {
                for (i = 1; i <= _segmentsW; ++i) {
                    var a:int = (_segmentsW + 1)*j + i;
                    var b:int = (_segmentsW + 1)*j + i - 1;
                    var c:int = (_segmentsW + 1)*(j - 1) + i - 1;
                    var d:int = (_segmentsW + 1)*(j - 1) + i;
                    
                    if (j == _segmentsH) {
						_indices.push(a,c,d);
						_faceLengths.push(3);
                    } else if (j == jMin) {
                    	_indices.push(a,b,c);
                    	_faceLengths.push(3);
                    } else {
                    	_indices.push(a,b,c,d);
                    	_faceLengths.push(4);
                    }
                }
            }
            
			if (!_openEnded)
				_segmentsH -= 1;
			
			_height *=2;
    	}
        
    	/**
    	 * Defines the radius of the cone base. Defaults to 100.
    	 */
    	public function get radius():Number
    	{
    		return _radius;
    	}
    	
    	public function set radius(val:Number):void
    	{
    		if (_radius == val)
    			return;
    		
    		_radius = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines the height of the cone. Defaults to 200.
    	 */
    	public override function get height():Number
    	{
    		return _height;
    	}
    	
    	public override function set height(val:Number):void
    	{
    		if (_height == val)
    			return;
    		
    		_height = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines the number of horizontal segments that make up the cone. Defaults to 8.
    	 */
    	public function get segmentsW():int
    	{
    		return _segmentsW;
    	}
    	
    	public function set segmentsW(val:int):void
    	{
    		if (_segmentsW == val)
    			return;
    		
    		_segmentsW = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines the number of vertical segments that make up the cone. Defaults to 1.
    	 */
    	public function get segmentsH():int
    	{
    		return _segmentsH;
    	}
    	
    	public function set segmentsH(val:int):void
    	{
    		if (_segmentsH == val)
    			return;
    		
    		_segmentsH = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines whether the end of the cone is left open (true) or closed (false). Defaults to false.
    	 */
    	public function get openEnded():Boolean
    	{
    		return _openEnded;
    	}
    	
    	public function set openEnded(val:Boolean):void
    	{
    		if (_openEnded == val)
    			return;
    		
    		_openEnded = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines whether the coordinates of the cone points use a yUp orientation (true) or a zUp orientation (false). Defaults to true.
    	 */
    	public function get yUp():Boolean
    	{
    		return _yUp;
    	}
    	
    	public function set yUp(val:Boolean):void
    	{
    		if (_yUp == val)
    			return;
    		
    		_yUp = val;
    		_primitiveDirty = true;
    	}
		
		/**
		 * Creates a new <code>Cone</code> object.
		 * 
		 * @param	material	Defines the global material used on the faces in the cone.
		 * @param	radius		Defines the radius of the cone base.
		 * @param	height		Defines the height of the cone.
		 * @param	segmentsW	Defines the number of horizontal segments that make up the cone.
		 * @param	segmentsH	Defines the number of vertical segments that make up the cone.
		 * @param	openEnded	Defines whether the end of the cone is left open (true) or closed (false).
		 * @param	yUp			Defines whether the coordinates of the cone points use a yUp orientation (true) or a zUp orientation (false).
		 */
        public function Cone(material:Material = null, radius:Number = 100, height:Number = 200, segmentsW:int = 8, segmentsH:int = 1, openEnded:Boolean = true, yUp:Boolean = true)
        {
            super(material);
			
			_radius = radius;
			_height = height;
			_segmentsW = segmentsW;
			_segmentsH = segmentsH;
			_openEnded = openEnded;
			_yUp = yUp;
			
            type = "Cone";
        	url = "primitive";
        }
		        
		/**
		 * Duplicates the cone properties to another <code>Cone</code> object.
		 * 
		 * @param	object	[optional]	The new object instance into which all properties are copied. The default is <code>Cone</code>.
		 * @return						The new object instance with duplicated properties applied.
		 */
        public override function clone(object:Object3D = null):Object3D
        {
            var cone:Cone = (object as Cone) || new Cone();
            super.clone(cone);
            cone.radius = _radius;
            cone.height = _height;
            cone.segmentsW = _segmentsW;
            cone.segmentsH = _segmentsH;
            cone.openEnded = _openEnded;
			cone.yUp = _yUp;
			cone._primitiveDirty = false;
			
			return cone;
        }
    }
}