package away3dlite.core.base;

import away3dlite.haxeutils.FastStd;
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
	private var _uvtData:Vector<Float>;
	private var _vertices:Vector<Float>;
	private var _screenVertices:Vector<Float>;
	
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
	public var faceIndex:Int;
	
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
	 * Index value of the fourth vertex in the face.
	 */
	public var i3:Int;
	
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
	 * x index of the fourth screen vertex.
	 */
	public var x3:Int;
	
	/**
	 * y index of the fourth screen vertex.
	 */
	public var y3:Int;
	
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
	
	/**
	 * u index of the fourth mapping value.
	 */
	public var u3:Int;
	
	/**
	 * v index of the fourth mapping value.
	 */
	public var v3:Int;
					
	/**
	 * t index of the fourth mapping value.
	 */
	public var t3:Int;
	
	/**
	 * Creates a new <code>Face</code> object.
	 * 
	 * @param mesh			The <code>Mesh</code> object to which the face belongs.
	 * @param faceIndex		The index of the face.
	 * @param index			The start index of the indices.
	 * @param length		The number of indices.
	 */
	public function new(mesh:Mesh, faceIndex:Int, index:Int, length:Int)
	{
		this.mesh = mesh;
		
		this.faceIndex = faceIndex;
		
		var _mesh_arcane:Dynamic = mesh;
		
		_uvtData = _mesh_arcane._uvtData;
		
		_vertices = _mesh_arcane._vertices;
		
		_screenVertices = _mesh_arcane._screenVertices;
		
		i0 = _mesh_arcane._indices[Std.int(index)];
		i1 = _mesh_arcane._indices[Std.int(index + 1)];
		i2 = _mesh_arcane._indices[Std.int(index + 2)];
		
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
		
		if (length > 3) {
			i3 = _mesh_arcane._indices[Std.int(index + 3)];
			x3 = 2*i3;
			y3 = 2*i3 + 1;
			u3 = 3*i3;
			v3 = 3*i3 + 1;
			t3 = 3*i3 + 2;
		}
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
		return (i3 != 0) ? Std.int((_uvtData[t0] + _uvtData[t1] + _uvtData[t2] + _uvtData[t3])*750000) : Std.int((_uvtData[t0] + _uvtData[t1] + _uvtData[t2])*1000000);
	}
	
	/**
	 * Returns the furthest screen Z coordinate of the face.
	 */
	public function calculateFurthestZ():Int
	{
		var z:Float = _uvtData[t0];
		
		if (z > _uvtData[t1])
			z = _uvtData[t1];
		
		if (z > _uvtData[t2])
			z = _uvtData[t2];
		
		if (i3 != 0 && z > _uvtData[t3])
			z = _uvtData[t3];
		
		return Std.int(z*3000000);
	}
	
	/**
	 * Returns the nearest screen Z coordinate of the face.
	 */
	public function calculateNearestZ():Int
	{
		var z:Float = _uvtData[t0];
		
		if (z < _uvtData[t1])
			z = _uvtData[t1];
		
		if (z < _uvtData[t2])
			z = _uvtData[t2];
		
		if (i3 != 0 && z < _uvtData[t3])
			z = _uvtData[t3];

		return Std.int(z * 3000000);
	}
	
	/**
	 * Returns the uvt coordinate of the face at the given screen coordinate.
	 * 
	 * @param x		The x value of the screen coordinate.
	 * @param y		The y value of the screen coordinate.
	 */
	public function calculateUVT(x:Float, y:Float):Vector3D
	{
		var v0x:Float = _vertices[x0];
		var v0y:Float = _vertices[y0];
		var v2x:Float = _vertices[x2];
		var v2y:Float = _vertices[y2];
		
		var ax:Float;
		var ay:Float;
		var az:Float;
		var au:Float;
		var av:Float;
		
		var bx:Float;
		var by:Float;
		var bz:Float;
		var bu:Float;
		var bv:Float;
		
		var cx:Float;
		var cy:Float;
		var cz:Float;
		var cu:Float;
		var cv:Float;
		
		if (i3 != 0 && (v0x*(v2y - y) + x*(v0y - v2y) + v2x*(y - v0y)) < 0) {
			az = _uvtData[t0];
			bz = _uvtData[t2];
			cz = _uvtData[t3];
			
			ax = (_screenVertices[x0] - x)/az;
			bx = (_screenVertices[x2] - x)/bz;
			cx = (_screenVertices[x3] - x)/cz;
			ay = (_screenVertices[y0] - y)/az;
			by = (_screenVertices[y2] - y)/bz;
			cy = (_screenVertices[y3] - y)/cz;
			
			au = _uvtData[u0];
			av = _uvtData[v0];
			bu = _uvtData[u2];
			bv = _uvtData[v2];
			cu = _uvtData[u3];
			cv = _uvtData[v3];
		} else {
			az = _uvtData[t0];
			bz = _uvtData[t1];
			cz = _uvtData[t2];
			
			ax = (_screenVertices[x0] - x)/az;
			bx = (_screenVertices[x1] - x)/bz;
			cx = (_screenVertices[x2] - x)/cz;
			ay = (_screenVertices[y0] - y)/az;
			by = (_screenVertices[y1] - y)/bz;
			cy = (_screenVertices[y2] - y)/cz;
			
			au = _uvtData[u0];
			av = _uvtData[v0];
			bu = _uvtData[u1];
			bv = _uvtData[v1];
			cu = _uvtData[u2];
			cv = _uvtData[v2];
		}
		
		var det:Float = ax*(by - cy) + bx*(cy - ay) + cx*(ay - by);
		
		var ad:Float = x*(by - cy) + bx*(cy - y) + cx*(y- by);
		var bd:Float = ax*(y - cy) + x*(cy - ay) + cx*(ay - y);
		var cd:Float = ax*(by - y) + bx*(y - ay) + x*(ay - by);
		
		return new Vector3D((ad*au + bd*bu + cd*cu)/det, (ad*av + bd*bv + cd*cv)/det, (ad/az + bd/bz + cd/cz)/det);
	}
}