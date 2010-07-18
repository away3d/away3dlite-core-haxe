package away3dlite.cameras.lenses;
import flash.geom.PerspectiveProjection;
import flash.geom.Vector3D;
import flash.Vector;

using away3dlite.namespace.Arcane;

class ZoomFocusLens extends AbstractLens
{

	/** @private */
	override /**arcane**/ function _update():Void
	{
		_view = _camera.arcaneNS()._view;
		_root = _view.root;
		_projection = _root.transform.perspectiveProjection;
		
		_projection.focalLength = _camera.zoom*_camera.focus;
		
		_projectionMatrix3D = _projection.toMatrix3D();
		_projectionMatrix3D.appendTranslation(0, 0, _camera.focus);
		
		_projectionData = _projectionMatrix3D.rawData;
		_projectionData[15] = _projectionData[14];
		_projectionMatrix3D.rawData = _projectionData;
	}
	
	private var _projection:PerspectiveProjection;
	private var _projectionData:Vector<Float>;
	
	public function new()
	{
		super();
	}
	
	public override function unProject(x:Float, y:Float, z:Float):Vector3D
	{
		var persp:Float = z/(_camera.zoom*_camera.focus);
		return new Vector3D(x*persp, y*persp, z - _camera.focus);
	}
	
}