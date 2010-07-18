package away3dlite.cameras.lenses;
import away3dlite.cameras.Camera3D;
import away3dlite.containers.View3D;
import flash.display.DisplayObject;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;

class AbstractLens 
{
	/** @private */
	/**arcane**/ var _view:View3D;
	/** @private */
	/**arcane**/ var _root:DisplayObject;
	/** @private */
	/**arcane**/ var _camera:Camera3D;
	/** @private */
	/**arcane**/ var _projectionMatrix3D:Matrix3D;		
	/** @private */
	/**arcane**/ function _update():Void
	{
		
	}
	
	private function new()
	{
		_projectionMatrix3D = new Matrix3D();
	}
	
	public function unProject(x:Float, y:Float, z:Float):Vector3D
	{
		return new Vector3D(x, y, z);
	}
}