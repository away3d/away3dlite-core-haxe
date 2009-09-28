package away3dlite.primitives
{
	import away3dlite.arcane;
	import away3dlite.core.base.*;
    import away3dlite.materials.*;
	
	use namespace arcane;
	
    /**
    * Creates a 3d torus primitive.
    */ 
    public class Torus extends AbstractPrimitive
    {
        private var _radius:Number = 100;
        private var _tube:Number = 40;
        private var _segmentsR:int = 8;
        private var _segmentsT:int = 6;
        private var _yUp:Boolean = true;
        
		/**
		 * @inheritDoc
		 */
    	protected override function buildPrimitive():void
    	{
    		super.buildPrimitive();
    		
            var i:int;
            var j:int;

            for (j = 0; j <= _segmentsR; ++j) {
                for (i = 0; i <= _segmentsT; ++i) {
                    var u:Number = i / _segmentsT * 2 * Math.PI;
                    var v:Number = j / _segmentsR * 2 * Math.PI;
                    var x:Number = (_radius + _tube*Math.cos(v))*Math.cos(u);
                    var y:Number = (_radius + _tube*Math.cos(v))*Math.sin(u);
                    var z:Number = _tube*Math.sin(v);
                    
                    _yUp? _vertices.push(x, -z, y) : _vertices.push(x, y, z);
                    
                    _uvtData.push(i/_segmentsT, 1 - j/_segmentsR, 1);
                }
            }

            
            for (j = 1; j <= _segmentsR; ++j) {
                for (i = 1; i <= _segmentsT; ++i) {
                    var a:int = (_segmentsT + 1)*j + i;
                    var b:int = (_segmentsT + 1)*j + i - 1;
                    var c:int = (_segmentsT + 1)*(j - 1) + i - 1;
                    var d:int = (_segmentsT + 1)*(j - 1) + i;
                    
                    	_indices.push(a,b,c);
						_indices.push(a,c,d);
                }
            }
    	}
    	
    	/**
    	 * Defines the overall radius of the torus. Defaults to 100.
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
    	 * Defines the tube radius of the torus. Defaults to 40.
    	 */
    	public function get tube():Number
    	{
    		return _tube;
    	}
    	
    	public function set tube(val:Number):void
    	{
    		if (_tube == val)
    			return;
    		
    		_tube = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines the number of radial segments that make up the torus. Defaults to 8.
    	 */
    	public function get segmentsR():Number
    	{
    		return _segmentsR;
    	}
    	
    	public function set segmentsR(val:Number):void
    	{
    		if (_segmentsR == val)
    			return;
    		
    		_segmentsR = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines the number of tubular segments that make up the torus. Defaults to 6.
    	 */
    	public function get segmentsT():Number
    	{
    		return _segmentsT;
    	}
    	
    	public function set segmentsT(val:Number):void
    	{
    		if (_segmentsT == val)
    			return;
    		
    		_segmentsT = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines whether the coordinates of the torus points use a yUp orientation (true) or a zUp orientation (false). Defaults to true.
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
		 * Creates a new <code>Torus</code> object.
		 * 
		 * @param	material	Defines the global material used on the faces in the torus.
		 * @param	radius		Defines the overall radius of the torus.
		 * @param	tube		Defines the tube radius of the torus.
		 * @param	segmentsR	Defines the number of radial segments that make up the torus.
		 * @param	segmentsT	Defines the number of tubular segments that make up the torus.
		 * @param	yUp			Defines whether the coordinates of the torus points use a yUp orientation (true) or a zUp orientation (false).
		 */
        public function Torus(material:Material = null, radius:Number = 100, tube:Number = 40, segmentsR:int = 8, segmentsT:int = 6, yUp:Boolean = true)
        {
            super(material);
        	
			_radius = radius;
			_tube = tube;
			_segmentsR = segmentsR;
			_segmentsT = segmentsT;
			_yUp = yUp;
			
			type = "Torus";
        	url = "primitive";
        }
        
		/**
		 * Duplicates the torus properties to another <code>Torus</code> object.
		 * 
		 * @param	object	[optional]	The new object instance into which all properties are copied. The default is <code>Torus</code>.
		 * @return						The new object instance with duplicated properties applied.
		 */
        public override function clone(object:Object3D = null):Object3D
        {
            var torus:Torus = (object as Torus) || new Torus();
            super.clone(torus);
            torus.radius = _radius;
            torus.tube = _tube;
            torus.segmentsR = _segmentsR;
            torus.segmentsT = _segmentsT;
			torus.yUp = _yUp;
			torus._primitiveDirty = false;
			
			return torus;
        }
    }
}
