package away3dlite.primitives;
import away3dlite.core.base.Face;
import away3dlite.core.base.Mesh;
import away3dlite.materials.Material;
import flash.Vector;

//use namespace arcane;
using away3dlite.namespace.Arcane;

/**
* Abstract base class for shaded primitives
*/ 
class AbstractPrimitive extends Mesh
{
	/** @private */
	/*arcane*/ private var _primitiveDirty:Bool;
	
	private function updatePrimitive():Void
	{
		buildPrimitive();
		
		buildFaces();
	}
	
	/**
	 * Builds the vertex, face and uv objects that make up the 3d primitive.
	 */
	private function buildPrimitive():Void
	{
		_primitiveDirty = false;
		
		_vertices.fixed = false;
		_uvtData.fixed = false;
		_indices.fixed = false;
		_faceLengths.fixed = false;
		
		_vertices.length = 0;
		_uvtData.length = 0;
		_indices.length = 0;
		_faceLengths.length = 0;
	}
	
	/**
	 * @inheritDoc
	 */
	private override function get_vertices():Vector<Float>
	{
		if (_primitiveDirty)
			updatePrimitive();
		
		return _vertices;
	}
	
	/**
	 * @inheritDoc
	 */
	private override function get_faces():Vector<Face>
	{
		if (_primitiveDirty)
			updatePrimitive();
		
		return super.get_faces();
	}
	
	/**
	 * Creates a new <code>AbstractPrimitive</code> object.
	 * 
	 * @param material		Defines the global material used on the faces in the primitive.
	 */
	public function new(?material:Material)
	{
		super(material);
		
		_primitiveDirty = true;
	}
}