package away3dlite.primitives
{
	import away3dlite.arcane;
	import away3dlite.core.base.*;
    import away3dlite.materials.*;
    
	use namespace arcane;
	
    /**
    * Creates a 3d sphere primitive.
    */ 
    public class Sphere extends AbstractPrimitive
    {
        private var _radius:Number = 100;
        private var _segmentsW:int = 8;
        private var _segmentsH:int = 6;
        private var _yUp:Boolean = true;
        
		/**
		 * @inheritDoc
		 */
    	protected override function buildPrimitive():void
    	{
    		super.buildPrimitive();
    		
            var i:int;
            var j:int;

            for (j = 0; j <= _segmentsH; ++j) { 
                var horangle:Number = Math.PI*j/_segmentsH;
                var z:Number = -_radius*Math.cos(horangle);
                var ringradius:Number = _radius*Math.sin(horangle);
                
                for (i = 0; i <= _segmentsW; ++i) { 
                    var verangle:Number = 2*Math.PI*i/_segmentsW;
                    var x:Number = ringradius*Math.cos(verangle);
                    var y:Number = ringradius*Math.sin(verangle);
                    
                    _yUp? _vertices.push(x, -z, y) : _vertices.push(x, y, z);
                    
                    _uvtData.push(i/_segmentsW, 1 - j/_segmentsH, 1);
                }
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
                    } else if (j == 1) {
                    	_indices.push(a,b,c);
						_faceLengths.push(3);
                    } else {
                    	_indices.push(a,b,c,d);
						_faceLengths.push(4);
					}
						
                }
            }
    	}
    	
    	/**
    	 * Defines the radius of the sphere. Defaults to 100.
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
    	 * Defines the number of horizontal segments that make up the sphere. Defaults to 8.
    	 */
    	public function get segmentsW():Number
    	{
    		return _segmentsW;
    	}
    	
    	public function set segmentsW(val:Number):void
    	{
    		if (_segmentsW == val)
    			return;
    		
    		_segmentsW = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines the number of vertical segments that make up the sphere. Defaults to 1.
    	 */
    	public function get segmentsH():Number
    	{
    		return _segmentsH;
    	}
    	
    	public function set segmentsH(val:Number):void
    	{
    		if (_segmentsH == val)
    			return;
    		
    		_segmentsH = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines whether the coordinates of the sphere points use a yUp orientation (true) or a zUp orientation (false). Defaults to true.
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
		 * Creates a new <code>Sphere</code> object.
		 * 
		 * @param	material	Defines the global material used on the faces in the sphere.
		 * @param	radius		Defines the radius of the sphere base.
		 * @param	segmentsW	Defines the number of horizontal segments that make up the sphere.
		 * @param	segmentsH	Defines the number of vertical segments that make up the sphere.
		 * @param	yUp			Defines whether the coordinates of the sphere points use a yUp orientation (true) or a zUp orientation (false).
		 */
        public function Sphere(material:Material = null, radius:Number = 100, segmentsW:int = 8, segmentsH:int = 6, yUp:Boolean = true)
        {
            super(material);
        	
			_radius = radius;
			_segmentsW = segmentsW;
			_segmentsH = segmentsH;
			_yUp = yUp;
			
			type = "Sphere";
        	url = "primitive";
        }
        
		/**
		 * Duplicates the sphere properties to another <code>Sphere</code> object.
		 * 
		 * @param	object	[optional]	The new object instance into which all properties are copied. The default is <code>Sphere</code>.
		 * @return						The new object instance with duplicated properties applied.
		 */
        public override function clone(object:Object3D = null):Object3D
        {
            var sphere:Sphere = (object as Sphere) || new Sphere();
            super.clone(sphere);
            sphere.radius = _radius;
            sphere.segmentsW = _segmentsW;
            sphere.segmentsH = _segmentsH;
			sphere.yUp = _yUp;
			sphere._primitiveDirty = false;
			
			return sphere;
        }
    }
}