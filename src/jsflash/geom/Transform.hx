/**
 * ...
 * @author waneck
 */

package jsflash.geom;
import jsflash.display.DisplayObject;

class Transform {
	
	//simplified version: no ColorTransform nor 2D Matrices. Must be implemented on this base class.
	//TODO implement 2D matrices + colorTransform
	public var matrix3D(default, set_matrix3D) : jsflash.geom.Matrix3D;
	
	private var displayObject:DisplayObject;
	
	//var colorTransform : ColorTransform;
	//var concatenatedColorTransform(default,null) : ColorTransform;
	//var concatenatedMatrix(default,null) : Matrix;
	//var matrix : Matrix;
	//var pixelBounds(default,null) : Rectangle;
	public function new(?displayObject : jsflash.display.DisplayObject) : Void
	{
		this.displayObject = displayObject;
		matrix3D = new Matrix3D();
	}
	
	public function set_matrix3D(val)
	{
		displayObject.Internal().matrix = val;
		return matrix3D = val;
	}
	
	public var perspectiveProjection : jsflash.geom.PerspectiveProjection;
	public function getRelativeMatrix3D( relativeTo:jsflash.display.DisplayObject ) : Matrix3D
	{
		//override me.
		return null;
	}
}