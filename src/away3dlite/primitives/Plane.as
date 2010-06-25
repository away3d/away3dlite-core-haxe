package away3dlite.primitives
{
	import away3dlite.arcane;
	import away3dlite.core.base.*;
    import away3dlite.materials.*;
    
	use namespace arcane;
	
    /**
    * Creates a 3d plane primitive.
    */ 
    public class Plane extends AbstractPrimitive
    {
    	private var _width:Number = 100;
        private var _height:Number = 100;
        private var _segmentsW:int = 1;
        private var _segmentsH:int = 1;
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
            	for (i = 0; i <= _segmentsW; ++i) {
                	_yUp? _vertices.push((i/_segmentsW - 0.5)*_width, 0, (j/_segmentsH - 0.5)*_height) : _vertices.push((i/_segmentsW - 0.5)*_width, (j/_segmentsH - 0.5)*_height, 0);
                	_uvtData.push(i/_segmentsW, 1 - j/_segmentsH, 1);
                }
            }
			
            for (j = 1; j <= _segmentsH; ++j) {
                for (i = 1; i <= _segmentsW; ++i) {
                    var a:int = (_segmentsW + 1)*j + i;
                    var b:int = (_segmentsW + 1)*j + i - 1;
                    var c:int = (_segmentsW + 1)*(j - 1) + i - 1;
                    var d:int = (_segmentsW + 1)*(j - 1) + i;
                    
                    _indices.push(a,b,c,d);
                    _faceLengths.push(4);
                }
            }
    	}
    	
    	/**
    	 * Defines the width of the plane. Defaults to 100.
    	 */
    	public override function get width():Number
    	{
    		return _width;
    	}
    	
    	public override function set width(val:Number):void
    	{
    		if (_width == val)
    			return;
    		
    		_width = val;
    		_primitiveDirty = true;
    	}
    	
    	/**
    	 * Defines the height of the plane. Defaults to 100.
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
    	 * Defines the number of horizontal segments that make up the plane. Defaults to 1.
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
    	 * Defines the number of vertical segments that make up the plane. Defaults to 1.
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
    	 * Defines whether the coordinates of the plane points use a yUp orientation (true) or a zUp orientation (false). Defaults to true.
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
		 * Creates a new <code>Plane</code> object.
		 * 
		 * @param	material	Defines the global material used on the faces in the plane.
		 * @param	width		Defines the width of the plane.
		 * @param	height		Defines the height of the plane.
		 * @param	segmentsW	Defines the number of horizontal segments that make up the plane.
		 * @param	segmentsH	Defines the number of vertical segments that make up the plane.
		 * @param	yUp			Defines whether the coordinates of the plane points use a yUp orientation (true) or a zUp orientation (false).
		 */
        public function Plane(material:Material = null, width:Number = 100, height:Number = 100, segmentsW:int = 1, segmentsH:int = 1, yUp:Boolean = true)
        {
            super(material);
			
			_width = width;
			_height = height;
			_segmentsW = segmentsW;
			_segmentsH = segmentsH;
			_yUp = yUp;
			
			type = "Plane";
        	url = "primitive";
        }
		        
		/**
		 * Duplicates the plane properties to another <code>Plane</code> object.
		 * 
		 * @param	object	[optional]	The new object instance into which all properties are copied. The default is <code>Plane</code>.
		 * @return						The new object instance with duplicated properties applied.
		 */
        public override function clone(object:Object3D = null):Object3D
        {
            var plane:Plane = (object as Plane) || new Plane();
            super.clone(plane);
            plane.width = _width;
            plane.height = _height;
            plane.segmentsW = _segmentsW;
            plane.segmentsH = _segmentsH;
			plane.yUp = _yUp;
			plane._primitiveDirty = false;
			
			return plane;
        }
    }
}
