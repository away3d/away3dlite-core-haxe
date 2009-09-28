//OK

package away3dlite.core.render;
import away3dlite.containers.ObjectContainer3D;
import away3dlite.core.base.Face;
import away3dlite.core.base.Mesh;
import away3dlite.core.base.Object3D;
import away3dlite.core.utils.Debug;
import away3dlite.materials.Material;
import flash.display.GraphicsTrianglePath;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.Lib;
import flash.utils.TypedDictionary;
import flash.Vector;

//use namespace arcane;
using away3dlite.namespace.Arcane;

/**
 * Standard renderer for a view.
 * 
 * @see away3dlite.containers.View3D
 */
class BasicRenderer extends Renderer
{
	private var _mesh:Mesh;
	//private var _screenVertices:Vector<Float>;
	private var _uvtData:Vector<Float>;
	private var _ind:Vector<Int>;
	private var _vert:Vector<Float>;
	private var _uvt:Vector<Float>;
	private var _material:Material;
	private var _triangles:GraphicsTrianglePath;
	private var _i:Int;
	private var _j:Int;
	private var _k:Int;
	
	private var _material_graphicsData:Vector<IGraphicsData>;
	
	// Layer
	private var _layers:flash.utils.TypedDictionary<Object3D, Sprite>;
	private var _graphicsDatas:flash.utils.TypedDictionary<Vector<IGraphicsData>, Sprite>;
	
	private function collectFaces(object:Object3D):Void
	{
		_mouseEnabledArray.push(_mouseEnabled);
		_mouseEnabled = object.arcane()._mouseEnabled = (_mouseEnabled && object.mouseEnabled);
		
		if (Std.is(object, ObjectContainer3D)) {
			var children:Array<Object3D> = Lib.as(object, ObjectContainer3D).children;
			var child:Object3D;
			
			for (child in children)
			{
				if(child.layer != null)
				{
					child.layer.graphics.clear();
					_layers.set(child, child.layer);
				}
				collectFaces(child);
			}
			
		} else if (Std.is(object, Mesh)) {
			var mesh:Mesh = Lib.as(object, Mesh);
			
			if(mesh.layer != null)
			{
				mesh.layer.graphics.clear();
				_layers.set(mesh, mesh.layer);
			}
					
			_clipping.arcane().collectFaces(mesh, _faces);
			
			if (_view.mouseEnabled && _mouseEnabled)
				collectScreenVertices(mesh);
			
			_view.arcane()._totalFaces += mesh.arcane()._faces.length;
		}
		
		_mouseEnabled = _mouseEnabledArray.pop();
		
		++_view.arcane()._totalObjects;
		++_view.arcane()._renderedObjects;
	}
	
	/** @private */
	private override function sortFaces():Void
	{
		super.sortFaces();
		
		//reorder indices
		_material = null;
		_mesh = null;
		
		i = -1;
		var x = 0;
		while (i++ < 255) {
			j = q1[i];
			while (j != 0) {
				x++;
				_face = _faces[j-1];
				
				if (_material != _face.material) 
				{
					if (_material != null) 
					{
						_material_graphicsData[_material.trianglesIndex] = _triangles;
						_view_graphics_drawGraphicsData(_material_graphicsData);
						
						if(_mesh.layer != null)
						{
							_mesh.layer.graphics.drawGraphicsData(_material_graphicsData);
							_graphicsDatas.set(_material_graphicsData, _mesh.layer);
						}else{
							_view_graphics_drawGraphicsData(_material_graphicsData);
						}
					}
					
					_ind.length = 0;
					_vert.length = 0;
					_uvt.length = 0;
					_i = -1;
					_j = -1;
					_k = -1;
					
					_mesh = _face.mesh;
					_material = _face.material;
					_material_graphicsData = _material.graphicsData;
					_screenVertices = _mesh.arcane()._screenVertices;
					_uvtData = _mesh.arcane()._uvtData;
					_faceStore.length = 0;
					_faceStore.length = Std.int(_mesh.arcane()._vertices.length/3);
				} else if (_mesh != _face.mesh) {
					_mesh = _face.mesh;
					_screenVertices = _mesh.arcane()._screenVertices;
					_uvtData = _mesh.arcane()._uvtData;
					_faceStore.length = 0;
					_faceStore.length = Std.int(_mesh.arcane()._vertices.length/3);
				}
				
				if (_faceStore[_face.i0] != 0) {
					_ind[++_i] = _faceStore[_face.i0] - 1;
				} else {
					_vert[++_j] = _screenVertices[_face.x0];
					_faceStore[_face.i0] = (_ind[++_i] = Std.int(_j*.5)) + 1;
					_vert[++_j] = _screenVertices[_face.y0];
					
					_uvt[++_k] = _uvtData[_face.u0];
					_uvt[++_k] = _uvtData[_face.v0];
					_uvt[++_k] = _uvtData[_face.t0];
				}
				
				if (_faceStore[_face.i1] != 0) {
					_ind[++_i] = _faceStore[_face.i1] - 1;
				} else {
					_vert[++_j] = _screenVertices[_face.x1];
					_faceStore[_face.i1] = (_ind[++_i] = Std.int(_j*.5)) + 1;
					_vert[++_j] = _screenVertices[_face.y1];
					
					_uvt[++_k] = _uvtData[_face.u1];
					_uvt[++_k] = _uvtData[_face.v1];
					_uvt[++_k] = _uvtData[_face.t1];
				}
				
				if (_faceStore[_face.i2] != 0) {
					_ind[++_i] = _faceStore[_face.i2] - 1;
				} else {
					_vert[++_j] = _screenVertices[_face.x2];
					_faceStore[_face.i2] = (_ind[++_i] = Std.int(_j*.5)) + 1;
					_vert[++_j] = _screenVertices[_face.y2];

					_uvt[++_k] = _uvtData[_face.u2];
					_uvt[++_k] = _uvtData[_face.v2];
					_uvt[++_k] = _uvtData[_face.t2];
				}
				
				j = np1[j];
			}
		}
	}
	
	/**
	 * Creates a new <code>BasicRenderer</code> object.
	 */
	public function new()
	{
		super();
		
		_graphicsDatas = new TypedDictionary<Vector<IGraphicsData>, Sprite>();
		_layers = new TypedDictionary<Object3D, Sprite>();
		_triangles = new GraphicsTrianglePath();
		
		_ind = _triangles.indices = new Vector<Int>();
		_vert = _triangles.vertices = new Vector<Float>();
		_uvt = _triangles.uvtData = new Vector<Float>();
	}
	
	/**
	 * @inheritDoc
	 */
	public override function getFaceUnderPoint(x:Float, y:Float):Face
	{
		if (_faces.length == 0)
			return null;
		
		collectPointVertices(x, y);
		
		_screenZ = 0;
		
		collectPointFace(x, y);
		
		return _pointFace;
	}
	
	/**
	 * @inheritDoc
	 */
	public override function render():Void
	{
		super.render();
		
		_faces.fixed = false;
		_faces.length = 0;
		
		collectFaces(_scene);
		
		_faces.fixed = true;
		
		_view.arcane()._renderedFaces = _faces.length;
		
		_scene.arcane()._dirtyFaces = false;
		
		if (_faces.length == 0)
			return;
		
		_sort.fixed = false;
		_sort.length = _faces.length;
		_sort.fixed = true;
		
		sortFaces();
		
		if (_material != null) 
		{
			_material_graphicsData = _material.graphicsData;
			_material_graphicsData[_material.trianglesIndex] = _triangles;
			
			for (layer in _layers)
			{
				if(_material_graphicsData != null && _graphicsDatas.get(_material_graphicsData) != null)
				{
					_graphicsDatas.get(_material_graphicsData).graphics.drawGraphicsData(_material_graphicsData);
					_material_graphicsData = null;
				}
			}
			
			if(_material_graphicsData != null)
				_view_graphics_drawGraphicsData(_material_graphicsData);
		}
		
	}
}
