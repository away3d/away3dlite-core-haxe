package away3dlite.primitives;
import away3dlite.materials.Material;
import flash.geom.Vector3D;


//use namespace arcane;
using away3dlite.namespace.Arcane;

/**
* Creates a single 3d line segment.
*/ 
class LineSegment extends AbstractPrimitive
{
	private var _start:Vector3D;
	private var _end:Vector3D;

	/**
	 * @inheritDoc
	 */
	private override function buildPrimitive():Void
	{
		super.buildPrimitive();
		
		_vertices.push(_start.x, _start.y, _start.z);
		_uvtData.push(0, 0, 0);
		
		_vertices.push(_end.x, _end.y, _end.z);
		_uvtData.push(0, 0, 0);
		
		_indices.push(0, 1, 1);
		_faceLengths.push(3);
	}
	
	/**
	 * Defines the starting position of the line segment. Defaults to (0, 0, 0).
	 */
	public var start(get_start, set_start):Vector3D;
	private function set_start(value:Vector3D):Vector3D
	{
		_start.x = value.x;
		_start.y = value.y;
		_start.z = value.z;
		
		_primitiveDirty = true;
		
		return value;
	}
	
	private inline function get_start():Vector3D
	{
		return _start;
	}
	
	/**
	 * Defines the ending position of the line segment. Defaults to (100, 100, 100).
	 */
	public var end(get_end, set_end):Vector3D;
	private function set_end(value:Vector3D):Vector3D
	{
		_end.x = value.x;
		_end.y = value.y;
		_end.z = value.z;
		
		_primitiveDirty = true;
		return value;
	}
	
	private inline function get_end():Vector3D
	{
		return _end;
	}
	
	/**
	 * Creates a new <code>LineSegment</code> object.
	 * 
	 * @param	material	Defines the global material used on the faces in the plane.
	 * @param	start		Defines the starting position of the line segment.
	 * @param	end			Defines the ending position of the line segment.
	 */
	public function new(?material:Material, ?start:Vector3D, ?end:Vector3D)
	{
		super(material);
		
		_start = (start != null) ? start : new Vector3D(0, 0, 0);
		_end = (end != null) ? end : new Vector3D(100, 100, 100);
		
		this.bothsides = true;
	}
}