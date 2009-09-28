//OK

package away3dlite.core.base;

import away3dlite.materials.Material;
import away3dlite.namespace.Arcane;
import flash.geom.Vector3D;
import flash.Vector;

//use namespace arcane;
using away3dlite.namespace.Arcane;

/**
 * Face value object. Stores information on each face in a mesh.
 */
class Face
{
	private var uvtData:Vector<Float>;
	
	private var vertices:Vector<Float>;
	
	private var screenVertices:Vector<Float>;
	
	/**
	 * Mesh object to which the face belongs.
	 */
	public var mesh:Mesh;
	
	/**
	 * Material of the face.
	 */
	public var material:Material;
	
	/**
	 * Index value of the face.
	 */
	public var index:Int;
	
	/**
	 * Index value of the first vertex in the face.
	 */
	public var i0:Int;
	
	/**
	 * Index value of the second vertex in the face.
	 */
	public var i1:Int;
	
	/**
	 * Index value of the third vertex in the face.
	 */
	public var i2:Int;
	
	/**
	 * x index of the first screen vertex.
	 */
	public var x0:Int;
	
	/**
	 * y index of the first screen vertex.
	 */
	public var y0:Int;
			
	/**
	 * x index of the second screen vertex.
	 */
	public var x1:Int;
			
	/**
	 * y index of the second screen vertex.
	 */
	public var y1:Int;
			
	/**
	 * x index of the third screen vertex.
	 */
	public var x2:Int;
			
	/**
	 * y index of the third screen vertex.
	 */
	public var y2:Int;
	
	/**
	 * u index of the first mapping value.
	 */
	public var u0:Int;
	
	/**
	 * v index of the first mapping value.
	 */
	public var v0:Int;
	
	/**
	 * t index of the first mapping value.
	 */
	public var t0:Int;
			
	/**
	 * u index of the second mapping value.
	 */
	public var u1:Int;
			
	/**
	 * v index of the second mapping value.
	 */
	public var v1:Int;
			
	/**
	 * t index of the second mapping value.
	 */
	public var t1:Int;
					
	/**
	 * u index of the third mapping value.
	 */
	public var u2:Int;
					
	/**
	 * v index of the third mapping value.
	 */
	public var v2:Int;
					
	/**
	 * t index of the third mapping value.
	 */
	public var t2:Int;
	
	/*
	public var normalX:Float;
	
	public var normalY:Float;
	
	public var normalZ:Float;
	*/
	
	public function new(mesh:Mesh, i:Int)
	{
		this.mesh = mesh;
		
		index = i;
		
		var _mesh_arcane = _MeshArcane.arcane_ns(mesh);
		
		uvtData = _mesh_arcane._uvtData;
		
		vertices = _mesh_arcane._vertices;
		
		screenVertices = _mesh_arcane._screenVertices;
		
		material = (_mesh_arcane._faceMaterials[i] != null) ? _mesh_arcane._faceMaterials[i] : mesh.material;
		
		i0 = _mesh_arcane._indices[Std.int(i*3 + 0)];
		i1 = _mesh_arcane._indices[Std.int(i*3 + 1)];
		i2 = _mesh_arcane._indices[Std.int(i*3 + 2)];
		
		x0 = 2*i0;
		y0 = 2*i0 + 1;
		
		x1 = 2*i1;
		y1 = 2*i1 + 1;
		
		x2 = 2*i2;
		y2 = 2*i2 + 1;
		
		u0 = 3*i0;
		v0 = 3*i0 + 1;
		t0 = 3*i0 + 2;
		
		u1 = 3*i1;
		v1 = 3*i1 + 1;
		t1 = 3*i1 + 2;
		
		u2 = 3*i2;
		v2 = 3*i2 + 1;
		t2 = 3*i2 + 2;
		
		/*
		var d1x:Float = vertices[u1] - vertices[u0];
		var d1y:Float = vertices[v1] - vertices[v0];
		var d1z:Float = vertices[t1] - vertices[t0];
	
		var d2x:Float = vertices[u2] - vertices[u0];
		var d2y:Float = vertices[v2] - vertices[v0];
		var d2z:Float = vertices[t2] - vertices[t0];
	
		var pa:Float = d1y*d2z - d1z*d2y;
		var pb:Float = d1z*d2x - d1x*d2z;
		var pc:Float = d1x*d2y - d1y*d2x;
		
		var pdd:Float = Math.sqrt(pa*pa + pb*pb + pc*pc);

		normalX = pa / pdd;
		normalY = pb / pdd;
		normalZ = pc / pdd;
		*/
	}
	
	/**
	 * selected function for calculating the screen Z coordinate of the face.
	 */
	public var calculateScreenZ:Void->Int;
	
	/**
	 * Returns the average screen Z coordinate of the face.
	 */
	public function calculateAverageZ():Int
	{
		return Std.int((uvtData[t0] + uvtData[t1] + uvtData[t2])*1000000);
	}
	
	/**
	 * Returns the furthest screen Z coordinate of the face.
	 */
	public function calculateFurthestZ():Int
	{
		var z:Float = uvtData[t0];
		
		if (z > uvtData[t1])
			z = uvtData[t1];
		
		if (z > uvtData[t2])
			z = uvtData[t2];
		
		return Std.int(z*1000000);
	}
	
	/**
	 * Returns the nearest screen Z coordinate of the face.
	 */
	public function calculateNearestZ():Int
	{
		var z:Float = uvtData[t0];
		
		if (z < uvtData[t1])
			z = uvtData[t1];
		
		if (z < uvtData[t2])
			z = uvtData[t2];
		
		return Std.int(z*1000000);
	}
	
	/**
	 * Returns the uvt coordinate of the face at the given screen coordinate.
	 * 
	 * @param x		The x value of the screen coordinate.
	 * @param y		The y value of the screen coordinate.
	 */
	public function calculateUVT(x:Float, y:Float):Vector3D
	{
		var az:Float = uvtData[t0];
		var bz:Float = uvtData[t1];
		var cz:Float = uvtData[t2];
		
		var ax:Float = (screenVertices[x0] - x)/az;
		var bx:Float = (screenVertices[x1] - x)/bz;
		var cx:Float = (screenVertices[x2] - x)/cz;
		var ay:Float = (screenVertices[y0] - y)/az;
		var by:Float = (screenVertices[y1] - y)/bz;
		var cy:Float = (screenVertices[y2] - y)/cz;

		var det:Float = ax*(by - cy) + bx*(cy - ay) + cx*(ay - by);
		
		var da:Float = x*(by - cy) + bx*(cy - y) + cx*(y- by);
		var db:Float = ax*(y - cy) + x*(cy - ay) + cx*(ay - y);
		var dc:Float = ax*(by - y) + bx*(y - ay) + x*(ay - by);

		return new Vector3D((da*uvtData[u0] + db*uvtData[u1] + dc*uvtData[u2])/det, (da*uvtData[v0] + db*uvtData[v1] + dc*uvtData[v2])/det, (da/uvtData[t0] + db/uvtData[t1] + dc/uvtData[t2])/det);
	}
}