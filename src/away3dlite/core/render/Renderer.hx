package away3dlite.core.render;

import away3dlite.containers.Scene3D;
import away3dlite.containers.View3D;
import away3dlite.core.base.Face;
import away3dlite.core.base.Mesh;
import away3dlite.core.clip.Clipping;
import away3dlite.haxeutils.FastStd;
import flash.display.GraphicsTrianglePath;
import flash.display.IGraphicsData;
import flash.Lib;
import flash.Vector;

//use namespace arcane;
using away3dlite.namespace.Arcane;

/**
 * @author robbateman
 */
class Renderer
{
	/** @private */
	/*arcane*/ private function setView(view:View3D):Void
	{
		_view = view;
		_view_graphics_drawGraphicsData = _view.graphics.drawGraphicsData;
	}
	
	private var k:Int;
	private var q0:Vector<Int>;
	private var np0:Vector<Int>;
	private var _screenVertexArrays:Vector<Vector<Float>>;
	private var _screenVertices:Vector<Float>;
	private var _screenPointVertexArrays:Vector<Vector<Int>>;
	private var _screenPointVertices:Vector<Int>;
	private var _index:Int;
	private var _indexX:Int;
	private var _indexY:Int;
	/** @private */
	private var i:Int;
	/** @private */
	private var j:Int;
	/** @private */
	private var q1:Vector<Int>;
	/** @private */
	private var np1:Vector<Int>;
	/** @private */
	private var _view:View3D;
	/** @private */
	private var _scene:Scene3D;
	/** @private */
	private var _face:Face;
	/** @private */
	private var _faces:Vector<Face>;
	/** @private */
	private var _sort:Vector<Int>;
	/** @private */
	private var _faceStore:Vector<Int>;
	/** @private */
	private var _clipping:Clipping;
	/** @private */
	private var _screenZ:Int;
	/** @private */
	private var _pointFace:Face;
	/** @private */
	private var _mouseEnabled:Bool;
	/** @private */
	private var _mouseEnabledArray:Vector<Bool>;
	/** @private */
	private var _ind:Vector<Int>;
	/** @private */
	private var _vert:Vector<Float>;
	/** @private */
	private var _uvt:Vector<Float>;
	/** @private */
	private var _triangles:GraphicsTrianglePath;
	/** @private */
	private var _view_graphics_drawGraphicsData:flash.Vector<IGraphicsData>->Void;
	
	/** @private */
	private function sortFaces():Void
	{
		// by pass
		var _faces_length_1:Int = Std.int(_faces.length + 1);
		
		q0 = new Vector<Int>(256, true);
		q1 = new Vector<Int>(256, true);
		np0 = new Vector<Int>(_faces_length_1, true);
		np1 = new Vector<Int>(_faces_length_1, true);
		
		i = 0;
		j = 0;
		
		for (_face in _faces)
		{
			np0[Std.int(i+1)] = q0[k = (255 & (_sort[i] = _face.calculateScreenZ()))];
			q0[k] = Std.int(++i);
		}
		
		i = 256;
		while (i-- > 0)
		{
			j = q0[i];
			while (j > 0)
			{
				np1[j] = q1[k = (65280 & _sort[Std.int(j-1)]) >> 8];
				j = np0[q1[k] = j];
			}
		}
	}
	
	/** @private */
	private function collectPointFace(x:Float, y:Float):Void
	{
		var pointCount:Int;
		var pointTotal:Int;
		var pointCountX:Int;
		var pointCountY:Int;
		var i:Int = _faces.length;
		while (i-- != 0) {
			_face = _faces[i];
			if (_screenZ < _sort[i] && _face.mesh.arcaneNS()._mouseEnabled) {
				_screenPointVertices = _screenPointVertexArrays[_face.mesh.arcaneNS()._vertexId];
				
				if (_face.i3 != 0) {
					pointTotal = 4;
					pointCount = _screenPointVertices[_face.i0] + _screenPointVertices[_face.i1] + _screenPointVertices[_face.i2] + _screenPointVertices[_face.i3];
				} else {
					pointTotal = 3;
					pointCount = _screenPointVertices[_face.i0] + _screenPointVertices[_face.i1] + _screenPointVertices[_face.i2];
				}
				
				pointCountX = (pointCount >> 4);
				pointCountY = (pointCount & 15);
				if (pointCountX != 0 && pointCountX < pointTotal && pointCountY != 0 && pointCountY < pointTotal) {
					
					//flagged for edge detection
					var vertices:Vector<Float> = _face.mesh.arcaneNS()._screenVertices;
					var v0x:Float = vertices[_face.x0];
					var v0y:Float = vertices[_face.y0];
					var v1x:Float = vertices[_face.x1];
					var v1y:Float = vertices[_face.y1];
					var v2x:Float = vertices[_face.x2];
					var v2y:Float = vertices[_face.y2];
					
					if ((v0x*(y - v1y) + v1x*(v0y - y) + x*(v1y - v0y)) < -0.001)
						continue;
						
					if ((x*(v2y - v1y) + v1x*(y - v2y) + v2x*(v1y - y)) < -0.001)
						continue;
					
					if (_face.i3 != 0) {
						var v3x:Float = vertices[_face.x3];
						var v3y:Float = vertices[_face.y3];
						
						if ((v3x*(v2y - y) + x*(v3y - v2y) + v2x*(y - v3y)) < -0.001)
							continue;
						
						if ((v0x*(v3y - y) + x*(v0y - v3y) + v3x*(y - v0y)) < -0.001)
							continue;
						
					} else if ((v0x*(v2y - y) + x*(v0y - v2y) + v2x*(y - v0y)) < -0.001) {
						continue;
					}
					
					_screenZ = _sort[i];
					_pointFace = _face;
				}
			}
		}
	}
	
	/** @private */
	private function collectScreenVertices(mesh:Mesh):Void
	{
		mesh.arcaneNS()._vertexId = _screenVertexArrays.length;
		_screenVertexArrays.push(mesh.arcaneNS()._screenVertices);
	}
	
	/** @private */
	private function collectPointVertices(x:Float, y:Float):Void
	{
		_screenPointVertexArrays.fixed = false;
		_screenPointVertexArrays.length = _screenVertexArrays.length;
		_screenPointVertexArrays.fixed = true;
		
		var i:Int = _screenVertexArrays.length;
		
		while (i-- != 0) {
			_screenVertices = _screenVertexArrays[i];
			_screenPointVertices = _screenPointVertexArrays[i] = new flash.Vector<Int>(_index = Std.int(_screenVertices.length / 2), true);
			
			while (_index-- != 0) {
				_indexY = (_indexX = _index*2) + 1;
				
				if (_screenVertices[_indexX] < x)
					_screenPointVertices[_index] += 0x10;
				
				if (_screenVertices[_indexY] < y)
					_screenPointVertices[_index] += 0x1;
			}
		}
	}
	
	/**
	 * Creates a new <code>Renderer</code> object.
	 */
	function new()
	{
		q1 = new Vector<Int>(256, true);
		_screenVertexArrays =  new Vector<Vector<Float>>();
		_screenPointVertexArrays = new Vector<Vector<Int>>();
		_faces = new Vector<Face>();
		_sort  = new Vector<Int>();
		_faceStore  = new Vector<Int>();
		_mouseEnabledArray  = new Vector<Bool>();
		_triangles = new GraphicsTrianglePath();
		
		_ind = _triangles.indices = new Vector<Int>();
		_vert = _triangles.vertices = new Vector<Float>();
		_uvt = _triangles.uvtData = new Vector<Float>();
	}
	
	/**
	 * Returns the face object directly under the given point.
	 * 
	 * @param x		The x coordinate of the point.
	 * @param y		The y coordinate of the point.
	 */
	public function getFaceUnderPoint(x:Float, y:Float):Face
	{
		//x;
		//y;
		return null;
	}
	
	/**
	 * Renders the contents of the scene to the view.
	 * 
	 * @see awa3dlite.containers.Scene3D
	 * @see awa3dlite.containers.View3D
	 */
	public function render():Void
	{
		_scene = _view.scene;
		
		_clipping = _view.arcaneNS().screenClipping;
		
		_mouseEnabled = _scene.mouseEnabled;
		_mouseEnabledArray.length = 0;
		_pointFace = null;
		
		_screenVertexArrays.length = 0;
	}
}