package away3dlite.loaders.data;
import away3dlite.animators.bones.SkinVertex;
import away3dlite.animators.bones.SkinController;
import flash.xml.XML;
import flash.Vector;

/**
 * Data class for the geometry data used in a mesh object
 */
class GeometryData
{
	/**
	 * The name of the geometry used as a unique reference.
	 */
	public var name:String;
	
	/**
	 * Array of vertex data.
	 */
	public var vertices:Vector<Float>;
	
	/**
	 * Array of skinvertex data.
	 */
	public var skinVertices:Vector<SkinVertex>;	
	/**
	 * Array of uv data.
	 */
	public var uvtData:Vector<Float>;
	
	/**
	 * Array of indices data.
	 */
	public var indices:Vector<Int>;
	
	/**
	 * Array of face indices length data.
	 */
	public var faceLengths:Vector<Int>;	
	
	/**
	 * Array of face data objects.
	 *
	 * @see away3dlite.loaders.data.FaceData
	 */
	public var faces:Array<FaceData>;
	
	/**
	 * Optional assigned materials to the geometry.
	 */
	public var materials:Array<MeshMaterialData>;
	
	/**
	 * Defines whether both sides of the geometry are visible
	 */
	public var bothsides:Bool;
	
	/**
	 * Array of skin controller objects used in bone animations
	 * 
	 * @see away3dlite.animators.skin.SkinController
	 */
	public var skinControllers:Array<SkinController>;
	
	/**
	 * Reference to the xml object defining the geometry.
	 */
	public var geoXML:XML;
	
	/**
	 * Reference to the xml object defining the controller.
	 */
	public var ctrlXML:XML;
	
	/**
	 * Returns the maximum x value of the geometry data
	 */
	public var maxX:Float;
	
	/**
	 * Returns the minimum x value of the geometry data
	 */
	public var minX:Float;
	
	/**
	 * Returns the maximum y value of the geometry data
	 */
	public var maxY:Float;
	
	/**
	 * Returns the minimum y value of the geometry data
	 */
	public var minY:Float;
	
	/**
	 * Returns the maximum z value of the geometry data
	 */
	public var maxZ:Float;
	
	/**
	 * Returns the minimum z value of the geometry data
	 */
	public var minZ:Float;
	
	public function new()
	{
		skinControllers = [];
		materials = [];
		faces = [];
		indices = new Vector<Int>();
		vertices = new Vector<Float>();
		skinVertices = new Vector<SkinVertex>();
		uvtData = new Vector<Float>();
		faceLengths = new Vector<Int>();
		
	}
}