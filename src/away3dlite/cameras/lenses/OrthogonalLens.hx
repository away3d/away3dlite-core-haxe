package away3dlite.cameras.lenses;
import flash.geom.Vector3D;

using away3dlite.namespace.Arcane;

class OrthogonalLens extends AbstractLens
{
	/** @private */
	override /**arcane**/ function _update():Void
	{
		_view = _camera.arcaneNS()._view;
		_scale = _camera.zoom / _camera.focus;			
		_projectionMatrix3D.identity();
		_projectionMatrix3D.appendScale(_scale, _scale, 1);
	}
	
	private var _scale:Float;

	public function new() 
	{
		super();
	}
	
	public override function unProject(x:Float, y:Float, z:Float):Vector3D
	{
		var scale = _camera.focus / _camera.zoom;
		return new Vector3D(x * scale, y * scale, z * scale);
	}
	
}