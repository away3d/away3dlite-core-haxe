/**
 * ...
 * @author waneck
 */

package ;
import away3dlite.core.base.Mesh;

class CubeTest extends Mesh
{

	public function new() 
	{
		super();
		
		setAll();
	}
	
	private function setAll():Void
	{
		_vertices = [
		  // Front face
		  -1.0, -1.0,  1.0,
		   1.0, -1.0,  1.0,
		   1.0,  1.0,  1.0,
		  -1.0,  1.0,  1.0,

		  // Back face
		  -1.0, -1.0, -1.0,
		  -1.0,  1.0, -1.0,
		   1.0,  1.0, -1.0,
		   1.0, -1.0, -1.0,

		  // Top face
		  -1.0,  1.0, -1.0,
		  -1.0,  1.0,  1.0,
		   1.0,  1.0,  1.0,
		   1.0,  1.0, -1.0,

		  // Bottom face
		  -1.0, -1.0, -1.0,
		   1.0, -1.0, -1.0,
		   1.0, -1.0,  1.0,
		  -1.0, -1.0,  1.0,

		  // Right face
		   1.0, -1.0, -1.0,
		   1.0,  1.0, -1.0,
		   1.0,  1.0,  1.0,
		   1.0, -1.0,  1.0,

		  // Left face
		  -1.0, -1.0, -1.0,
		  -1.0, -1.0,  1.0,
		  -1.0,  1.0,  1.0,
		  -1.0,  1.0, -1.0,
		];
		
			_uvtData = [
		  1.0, 0.0, 0.0, 1.0,     // Front face
		  1.0, 1.0, 0.0, 1.0,     // Back face
		  0.0, 1.0, 0.0, 1.0,     // Top face
		  1.0, 0.5, 0.5, 1.0,     // Bottom face
		  1.0, 0.0, 1.0, 1.0,     // Right face
		  0.0, 0.0, 1.0, 1.0,     // Left face
		];
		
		_indices = [
		  0, 1, 2,      0, 2, 3,    // Front face
		  4, 5, 6,      4, 6, 7,    // Back face
		  8, 9, 10,     8, 10, 11,  // Top face
		  12, 13, 14,   12, 14, 15, // Bottom face
		  16, 17, 18,   16, 18, 19, // Right face
		  20, 21, 22,   20, 22, 23  // Left face
		];
		
		buildFaces();
	}
	
}