package away3dlite.cameras.lenses;
import flash.geom.PerspectiveProjection;
import flash.geom.Vector3D;

using away3dlite.namespace.Arcane;

class PerspectiveLens extends AbstractLens
{

	/** @private */
	override /**arcane**/ function _update():Void
	{
		_view = _camera.arcaneNS()._view;
		_root = _view.root;
		_projection = _root.transform.perspectiveProjection;
		
		_projection.focalLength = _camera.zoom*_camera.focus;
		
		_projectionMatrix3D = _projection.toMatrix3D();
	}
	
	private var _projection:PerspectiveProjection;
	
	public function new()
	{
		super();
	}
	
	public override function unProject(x:Float, y:Float, z:Float):Vector3D
	{
		var persp:Float = z/(_camera.zoom*_camera.focus);
		return new Vector3D(x*persp, y*persp, z);
	}
	
}