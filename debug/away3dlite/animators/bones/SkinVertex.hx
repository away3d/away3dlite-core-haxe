package away3dlite.animators.bones;

import flash.geom.Vector3D;
import flash.Vector;


class SkinVertex
{
	private var _i:Int;
	private var _position:Vector3D;
	private var _output:Vector3D;
	private var _startIndex:Int;
	private var _vertices:Vector<Float>;
	private var _baseVertex:Vector3D;
	
	public var weights:Vector<Float>;
	
	public var controllers:Vector<SkinController>;
	
	public function new()
	{
		_position = new Vector3D();
		weights = new Vector<Float>();
		controllers = new Vector<SkinController>();
	}
	
	public function updateVertices(startIndex:Int, vertices:Vector<Float>)
	{
		_startIndex = startIndex;
		_vertices = vertices;
		_baseVertex = new Vector3D(_vertices[_startIndex], _vertices[_startIndex + 1], _vertices[_startIndex + 2]);
	}
	
	public function update()
	{
		//reset values
		_output = new Vector3D();
		
		_i = weights.length;
		while (_i-- != 0) {
			_position = controllers[_i].transformMatrix3D.transformVector(_baseVertex);
			_position.scaleBy(weights[_i]);
			_output = _output.add(_position);
		}
		
		_vertices[Std.int(_startIndex)] = _output.x;
		_vertices[Std.int(_startIndex + 1)] = _output.y;
		_vertices[Std.int(_startIndex + 2)] = _output.z;
	}
	
	public function clone():SkinVertex
	{
		var skinVertex:SkinVertex = new SkinVertex();
		skinVertex.weights = weights;
		skinVertex.controllers = controllers;
		
		return skinVertex;
	}
}