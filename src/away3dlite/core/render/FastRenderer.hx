package away3dlite.core.render;

import away3dlite.containers.ObjectContainer3D;
import away3dlite.core.base.Face;
import away3dlite.core.base.Mesh;
import away3dlite.core.base.Object3D;
import away3dlite.core.utils.Debug;
import away3dlite.haxeutils.FastStd;
import away3dlite.materials.Material;
import flash.display.IGraphicsData;
import flash.Lib;
import flash.Vector;

//use namespace arcane;
using away3dlite.namespace.Arcane;

/**
 * @author robbateman
 */
class FastRenderer extends Renderer
{
	private var _i:Int;
	private var _x:Float;
	private var _y:Float;
	private var children:Array<Object3D>;
	
	private function collectFaces(object:Object3D):Void
	{
		if (!object.visible)
			return;
		
		_mouseEnabledArray.push(_mouseEnabled);
		_mouseEnabled = object.arcaneNS()._mouseEnabled = (_mouseEnabled && object.mouseEnabled);
		
		if (FastStd.is(object, ObjectContainer3D)) {
			children = Lib.as(object, ObjectContainer3D).children;
			var child:Object3D;
			
			if (sortObjects)
				untyped children.sortOn("_screenZ", 18);
				
			for (child in children) {
				if(child.layer != null)
					child.layer.graphics.clear();
				
				collectFaces(child);
			}
		}
		
		var mesh:Mesh = Lib.as(object, Mesh);
		
		_faces = mesh.arcaneNS()._faces;
		
		if(_faces.length == 0)
			return;
		
		var _mesh_material:Material = mesh.material;
		var _mesh_material_graphicsData:Vector<IGraphicsData> = _mesh_material.graphicsData;
		
		_mesh_material_graphicsData[_mesh_material.trianglesIndex] = _triangles;
		
		_ind.fixed = false;
		_sort = mesh.arcaneNS()._sort;
		_triangles.culling = mesh.arcaneNS()._culling;
		_uvt = _triangles.uvtData = mesh.arcaneNS()._uvtData;
		_vert = _triangles.vertices = mesh.arcaneNS()._screenVertices;
		_ind.length = mesh.arcaneNS()._indicesTotal;
		_ind.fixed = true;
		
		if (_view.mouseEnabled && _mouseEnabled)
			collectScreenVertices(mesh);
		
		if (mesh.sortFaces) {
			sortFaces();
		} else {
			j = _faces.length;
			_i = -1;
			while (j-- != 0) {
				_face = _faces[j];
				_ind[Std.int(++_i)] = _face.i0;
				_ind[Std.int(++_i)] = _face.i1;
				_ind[Std.int(++_i)] = _face.i2;
				
				if (_face.i3 != 0) {
					_ind[Std.int(++_i)] = _face.i0;
					_ind[Std.int(++_i)] = _face.i2;
					_ind[Std.int(++_i)] = _face.i3;
				}
			}
		}
		
		if(object.layer != null)
		{
			object.layer.graphics.drawGraphicsData(_mesh_material_graphicsData);
		}else{
			_view_graphics_drawGraphicsData(_mesh_material_graphicsData);
		}
		
		var _faces_length:Int = _faces.length;
		_view.arcaneNS()._totalFaces += _faces_length;
		_view.arcaneNS()._renderedFaces += _faces_length;
		
		_mouseEnabled = _mouseEnabledArray.pop();
		
		++_view.arcaneNS()._totalObjects;
		++_view.arcaneNS()._renderedObjects;
	}
	
	private function collectPointFaces(object:Object3D):Void
	{
		if (FastStd.is(object, ObjectContainer3D)) {
			var children:Array<Object3D> = Lib.as(object, ObjectContainer3D).children;
			var child:Object3D;
			
			for (child in children)
				collectPointFaces(child);
			
		} else if (FastStd.is ( object,  Mesh ) ) {
			var mesh:Mesh = Lib.as(object, Mesh);
			
			_faces = mesh.arcaneNS()._faces;
			_sort = mesh.arcaneNS()._sort;
			
			collectPointFace(_x, _y);
		}
	}
	
	/** @private */
	private override function sortFaces():Void
	{
		super.sortFaces();
		
		i = -1;
		_i = -1;
		while (i++ < 255) {
			j = q1[i];
			while (j != 0) {
				_face = _faces[j - 1];
				_ind[Std.int(++_i)] = _face.i0;
				_ind[Std.int(++_i)] = _face.i1;
				_ind[Std.int(++_i)] = _face.i2;
				
				if (_face.i3 != 0) {
					_ind[Std.int(++_i)] = _face.i0;
					_ind[Std.int(++_i)] = _face.i2;
					_ind[Std.int(++_i)] = _face.i3;
				}
				
				j = np1[j];
			}
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public override function getFaceUnderPoint(x:Float, y:Float):Face
	{
		_x = x;
		_y = y;
		
		collectPointVertices(x, y);
		
		_screenZ = 0;
		
		collectPointFaces(_scene);
		
		return _pointFace;
	}
	
	/**
	 * Determines whether 3d objects are sorted in the view. Defaults to true.
	 */
	public var sortObjects:Bool;
	
	/**
	 * Creates a new <code>FastRenderer</code> object.
	 */
	public function new()
	{
		super();
		
		sortObjects = true;
	}
	
	/**
	 * @inheritDoc
	 */
	public override function render():Void
	{
		super.render();
		
		collectFaces(_scene);
	}
}