package jsflash.geom;
import jsflash.Lib;
import jsflash.geom.Point;
import jsflash.Vector;
import jsflash.geom.Matrix3D;


class PerspectiveProjection
{
	public var projectionCenter(default, set_projectionCenter):Point; //FIXME: untested compatibility
	public var fieldOfView(default, set_fieldOfView):Float;
	public var focalLength(default, set_focalLength):Float;
	
	public var Znear:Float;
	public var Zfar:Float;
	public var Aspect:Float;
	
	private var matrix:Matrix3D;	
	
	public function new()
	{
		projectionCenter = new Point(0,0);
		this.fieldOfView = 55;
		Znear = 0.1;
		Zfar = 1000;
		Aspect = 1;
	}
    
    public function PerspectiveMatrix3D( ?pixelPerUnitRatio:Float = 250 ):Matrix3D 
    {
		var ymax = Znear * Math.tan(this.fieldOfView * Math.PI / 360);
		var ymin = -ymax;
		var xmin = ymin * Aspect;
		var xmax = ymax * Aspect;
        
        return new Matrix3D( makeFrustum(xmin, xmax, ymin, ymax, Znear, Zfar) );
    }

	public static inline function makeFrustum(left:Float, right:Float, bottom:Float, top:Float, znear:Float, zfar:Float):Vector<Float>
	{
		var X = 2*znear/(right-left);
	    var Y = 2*znear/(top-bottom);
	    var A = (right+left)/(right-left);
	    var B = (top+bottom)/(top-bottom);
	    var C = -(zfar+znear)/(zfar-znear);
	    var D = -2*zfar*znear/(zfar-znear);

	    return Lib.vectorOfArray(
				[X, 0, 0, 0,
	            0, Y, 0, 0,
	            A, B, C, -1,
	            0, 0, D, 0]);
	}
	

	public inline function Internal():InternalPerspectiveProjection
	{
		return cast this;
	}
    
    /**
     * Converts a perspective projection to a pespective matrix, taking
     * into account the projection center.
     * 
     * @param    pp                    the perspective projection
     * @param    pixelPerUnitRatio    the pixel per unit ratio
     * @return    the perspective matrix
     */
    public function toMatrix3D(?pixelPerUnitRatio:Float = 250):Matrix3D
    {
        var fov:Float = fieldOfView;
        var cx:Float = projectionCenter.x;
        var cy:Float = projectionCenter.y;
        
        return PerspectiveMatrix3D(pixelPerUnitRatio);
    }
    
    /**
     * Converts a field of view to a focal length.
     * @param    fov    the field of view
     * @return    the focal length
     */
    inline function focalLengthFromFoV(fov:Float):Float
    {
        return -.5 * Math.cos(fov * .5) / Math.sin(fov * .5);
    }

	inline function fovFromFocalLength(fl:Float):Float
    {
		return 2*Math.atan(1/(fl*-2));
    }

	
	private function set_projectionCenter(val)
	{
		return projectionCenter = val;
	}
	
	private function set_fieldOfView(val)
	{
		this.Internal().focalLength = focalLengthFromFoV(val);
		return fieldOfView = val;
	}
	
	private function set_focalLength(val)
	{
		this.Internal().fieldOfView = fovFromFocalLength(val);
		return focalLength = val;
	}
    
}

private typedef InternalPerspectiveProjection = 
{
	public var projectionCenter : Point;
	public var fieldOfView : Float;
	public var focalLength : Float;
	
	private var matrix:Matrix3D;
}