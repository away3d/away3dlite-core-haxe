package away3dlite.core.clip;
import away3dlite.core.base.Face;
import away3dlite.core.base.Mesh;
import flash.Lib;
import flash.Vector;

//use namespace arcane;
using away3dlite.namespace.Arcane;

/**
* Rectangle clipping
*/
class RectangleClipping extends Clipping
{
	/** @private */
	/*arcane*/ private override function collectFaces(mesh:Mesh, faces:Vector<Face>):Void
	{
		_faces = mesh.arcaneNS()._faces;
		_uvtData = mesh.arcaneNS()._uvtData;
		_screenVertices = mesh.arcaneNS()._screenVertices;
		
		_screenVerticesCull = new Vector<Int>();
		_index = _screenVerticesCull.length = Std.int( _screenVertices.length/2 );
		_screenVerticesCull.fixed = true;
		
		while (_index-- != 0) {
			_indexX = _index*2;
			_indexY = _indexX + 1;
			_indexZ = _index*3 + 2;
			
			if (_uvtData[_indexZ] < 0) {
				_screenVerticesCull[_index] += 256;
			} else {
				if (_screenVertices[_indexX] < _minX)
					_screenVerticesCull[_index] += 64;
				else if (_screenVertices[_indexX] > _maxX)
					_screenVerticesCull[_index] += 16;
				
				if (_screenVertices[_indexY] < _minY)
					_screenVerticesCull[_index] += 4;
				else if (_screenVertices[_indexY] > _maxY)
					_screenVerticesCull[_index] += 1;
			}
		}
		
		for (_face in _faces) {
			if (mesh.bothsides || _screenVertices[_face.x0]*(_screenVertices[_face.y2] - _screenVertices[_face.y1]) + _screenVertices[_face.x1]*(_screenVertices[_face.y0] - _screenVertices[_face.y2]) + _screenVertices[_face.x2]*(_screenVertices[_face.y1] - _screenVertices[_face.y0]) > 0) {
				/*
				if (_face.i3 != 0)
				{
					_cullTotal = 4;
					_cullCount = _screenVerticesCull[_face.i0] + _screenVerticesCull[_face.i1] + _screenVerticesCull[_face.i2] + _screenVerticesCull[_face.i3];
				} else {
					_cullTotal = 3;*/
					_cullCount = _screenVerticesCull[_face.i0] + _screenVerticesCull[_face.i1] + _screenVerticesCull[_face.i2];
				//}
				//HAXE_WARNING
				//WARNING
				//last revision not working properly
       			//if ((_cullCount >> 16 == 0) && (_cullCount >> 12 & 15) < _cullTotal && (_cullCount >> 8 & 15) < _cullTotal && (_cullCount >> 4 & 15) < _cullTotal && (_cullCount & 15) < _cullTotal)
				if ((_cullCount >> 8 == 0) && (_cullCount >> 6 & 3 ) < 3 && (_cullCount >> 4 & 3) < 3 && (_cullCount >> 2 & 3) < 3 && (_cullCount & 3) < 3)
					faces[faces.length] = _face;
			}
		}
	}
	
	/**
	 * Creates a new <code>RectangleClipping</code> object.
	 * 
	 * @param minX	Minimum allowed x value for primitives.
	 * @param maxX	Maximum allowed x value for primitives.
	 * @param minY	Minimum allowed y value for primitives.
	 * @param maxY	Maximum allowed y value for primitives.
	 * @param minZ	Minimum allowed z value for primitives.
	 * @param maxZ	Maximum allowed z value for primitives.
	 */
	public function new(?minX:Float = -100000, ?maxX:Float = 100000, ?minY:Float = -100000, ?maxY:Float = 100000, ?minZ:Float = -100000, ?maxZ:Float = 100000)
	{
		super(minX, maxX, minY, maxY, minZ, maxZ);
	}
	
	public override function clone(?object:Clipping):Clipping
	{
		var clipping:RectangleClipping = (object != null) ? Lib.as(object, RectangleClipping) : new RectangleClipping();
		
		super.clone(clipping);
		
		return clipping;
	}
}