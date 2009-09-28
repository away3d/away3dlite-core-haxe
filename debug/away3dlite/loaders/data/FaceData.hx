package away3dlite.loaders.data;

/**
 * Data class for a face object.
 */
class FaceData
{
	/**
	 * Index of vertex 0.
	 */
	public var v0:Int;
	
	/**
	 * Index of vertex 1.
	 */
	public var v1:Int;
	
	/**
	 * Index of vertex 2.
	 */
	public var v2:Int;
	
	/**
	 * Index of uv coordinate 0.
	 */
	public var uv0:Int;
	
	/**
	 * Index of uv coordinate 1.
	 */
	public var uv1:Int;
	
	/**
	 * Index of uv coordinate 2.
	 */
	public var uv2:Int;
	
	/**
	 * Determines whether the face is visible.
	 */
	public var visible:Bool;
	
	/**
	 * Holds teh material data for the face.
	 */
	public var materialData:MaterialData;
	
	public function new()
	{
		
	}
}