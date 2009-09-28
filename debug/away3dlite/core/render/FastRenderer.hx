//OK

package away3dlite.core.render;
import away3dlite.containers.ObjectContainer3D;
import away3dlite.core.base.Face;
import away3dlite.core.base.Mesh;
import away3dlite.core.base.Object3D;
import away3dlite.core.utils.Debug;
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
	private var _indices:Vector<Int>;
	private var _uvtData:Vector<Float>;
	private var _i:Int;
	private var _x:Float;
	private var _y:Float;
	private var children:Array<Object3D>;
	
	private function collectFaces(object:Object3D):Void
	{
		Lib.trace(Std.is(object, Object3D));
		_mouseEnabledArray.push(_mouseEnabled);
		_mouseEnabled = object.arcane()._mouseEnabled = (_mouseEnabled && object.mouseEnabled);
		
		if (Std.is(object, ObjectContainer3D)) {
			children = Lib.as(object, ObjectContainer3D).children;
			var child:Object3D;
			
			if (sortObjects)
				untyped children.sortOn("_screenZ", 18);
				
			for (child in children) {
				if(child.layer != null)
					child.layer.graphics.clear();
				
				collectFaces(child);
			}
			
		} else if (Std.is(object, Mesh)) {
			
			var mesh:Mesh = Lib.as(object, Mesh);
			var _mesh_material:Material = mesh.material;
			var _mesh_material_graphicsData:Vector<IGraphicsData> = _mesh_material.graphicsData;
			
			_mesh_material_graphicsData[_mesh_material.trianglesIndex] = mesh.arcane()._triangles;
			
			_faces = mesh.arcane()._faces;
			_sort = mesh.arcane()._sort;
			_indices = mesh.arcane()._indices;
			_uvtData = mesh.arcane()._uvtData;
			
			if(_faces.length == 0)
				return;
			
			if (_view.mouseEnabled && _mouseEnabled)
				collectScreenVertices(mesh);
			
			if (mesh.sortFaces)
				sortFaces();
			
			if(object.layer != null)
			{
				object.layer.graphics.drawGraphicsData(_mesh_material_graphicsData);
			}else{
				_view_graphics_drawGraphicsData(_mesh_material_graphicsData);
			}
			
			var _faces_length:Int = _faces.length;
			_view.arcane()._totalFaces += _faces_length;
			_view.arcane()._renderedFaces += _faces_length;
		}
		
		_mouseEnabled = _mouseEnabledArray.pop();
		
		++_view.arcane()._totalObjects;
		++_view.arcane()._renderedObjects;
	}
	
	private function collectPointFaces(object:Object3D):Void
	{
		if (Std.is(object, ObjectContainer3D)) {
			var children:Array<Object3D> = Lib.as(object, ObjectContainer3D).children;
			var child:Object3D;
			
			for (child in children)
				collectPointFaces(child);
			
		} else if (Std.is ( object,  Mesh ) ) {
			var mesh:Mesh = Lib.as(object, Mesh);
			
			_faces = mesh.arcane()._faces;
			_sort = mesh.arcane()._sort;
			
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
				_face = _faces[j-1];
				_indices[Std.int(++_i)] = _face.i0;
				_indices[Std.int(++_i)] = _face.i1;
				_indices[Std.int(++_i)] = _face.i2;
				
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
		Lib.trace("new ok");
		super.render();
		
		collectFaces(_scene);
	}
	
	/*
	private function quicksort( lo : Int, hi : Int ) : Void {
			var i = lo;
			var j = hi;
			var tbuf = children;
			Lib.trace(lo + " H " + hi);
			var p = untyped tbuf[(lo+hi)>>1]._screenZ;
			while( i <= j ) {
					while (i < hi && untyped tbuf[i]._screenZ > p ) i++;
					while (i > lo && untyped tbuf[j]._screenZ < p ) j--;
					if( i <= j ) {
							var t = tbuf[i];
							tbuf[i++] = tbuf[j];
							tbuf[j--] = t;
					}
			}
			if( lo < j ) quicksort( lo, j );
			if( i < hi ) quicksort( i, hi );
	}*/

}