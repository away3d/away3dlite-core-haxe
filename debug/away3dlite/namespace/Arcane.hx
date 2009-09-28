/**
 * haXe package to emulate arcane namespace access. Should be used with using keyword.
 * @author waneck
 */

package away3dlite.namespace;
//import away3dlite.namespace.Arcanedef;

class _RendererArcane
{
	public static inline function arcane(obj : away3dlite.core.render.Renderer) : _Renderer
	{
		return obj;
	}
}

class _ClippingArcane
{
	public static function arcane(obj : away3dlite.core.clip.Clipping) : _Clipping
	{
		return obj;
	}
}

class _View3DArcane
{
	public static inline function arcane(obj : away3dlite.containers.View3D) : _View3D
	{
		return obj;
	}
}

class _AbstractPrimitiveArcane
{
	public static inline function arcane(obj : away3dlite.loaders.AbstractParser) : _AbstractParser
	{
		return obj;
	}
}

class _Camera3DArcane
{
	public static inline function arcane(obj : away3dlite.cameras.Camera3D) : _Camera3D
	{
		return obj;
	}
}

class _AbstractParserArcane
{
	public static inline function arcane(obj : away3dlite.loaders.AbstractParser) : _AbstractParser
	{
		return obj;
	}
}

class _Scene3DArcane
{
	public static inline function arcane(obj : away3dlite.containers.Scene3D) : _Scene3D
	{
		return obj;
	}
}

class _ObjectContainer3DArcane
{
	public static inline function arcane(obj : away3dlite.containers.ObjectContainer3D) : _ObjectContainer3D
	{
		return obj;
	}
}

class _MeshArcane
{
	public static inline function arcane(obj : away3dlite.core.base.Mesh) : _Mesh
	{
		return obj;
	}
	
	public static function arcane_ns(obj : away3dlite.core.base.Mesh) : _Mesh
	{
		return obj;
	}
}

class _Object3DArcane
{
	public static inline function arcane(obj : away3dlite.core.base.Object3D) : _Object3D
	{
		return obj;
	}
}



import away3dlite.containers.Scene3D;
import away3dlite.containers.View3D;
import away3dlite.core.base.Mesh;
import away3dlite.core.clip.Clipping;
import away3dlite.events.ParserEvent;
import away3dlite.materials.Material;
import flash.display.GraphicsTrianglePath;
import flash.display.Sprite;
import flash.geom.Matrix3D;
import away3dlite.core.base.Face;
import flash.Vector;

private typedef _Renderer =
{
	/*arcane*/ private function setView(view:View3D):Void;
}

private typedef _Clipping =
{
	/*arcane*/ private function setView(view:View3D):Void;
	/*arcane*/ private function collectFaces(mesh:Mesh, faces:Vector<Face>):Void;
	/*arcane*/ private function screen(container:Sprite, _loaderWidth:Float, _loaderHeight:Float):Clipping;
}

private typedef _View3D =
{
	/** @private */
	/*arcane*/ private var _totalFaces:Int;
	/** @private */
	/*arcane*/ private var _totalObjects:Int;
	/** @private */
	/*arcane*/ private var _renderedFaces:Int;
	/** @private */
	/*arcane*/ private var _renderedObjects:Int;
	/** @private */
	/*arcane*/ private var screenClipping(get_screenClipping, null):Clipping;
	/*arcane*/ private function get_screenClipping():Clipping;
}

private typedef _AbstractParser =
{
	/** @private */
	/*arcane*/ private var _container : away3dlite.core.base.Object3D;
	/** @private */
	/*arcane*/ private var binary:Bool;
	/** @private */
	/*arcane*/ private var _totalChunks:Int;
	/** @private */
	/*arcane*/ private var _parsedChunks:Int;
	/** @private */
	/*arcane*/ private var _parsesuccess:ParserEvent;
	/** @private */
	/*arcane*/ private var _parseerror:ParserEvent;
	/** @private */
	/*arcane*/ private var _parseprogress:ParserEvent;
	/** @private */
	/*arcane*/ private function notifyProgress():Void;
	/** @private */
	/*arcane*/ private function notifySuccess():Void;
	/** @private */
	/*arcane*/ private function notifyError():Void;
	/** @private */
	/*arcane*/ private function prepareData(data:Dynamic):Void;
	/** @private */
	/*arcane*/ private function parseNext():Void;
}


private typedef _Object3D =
{
	/** @private */
	/*arcane*/ private var _screenZ:Float;
	/** @private */
	/*arcane*/ private var _scene:Scene3D;
	/** @private */
	/*arcane*/ private var _viewMatrix3D:Matrix3D;
	/** @private */
	/*arcane*/ private var _sceneMatrix3D:Matrix3D;
	/** @private */
	/*arcane*/ private var _mouseEnabled:Bool;
	/** @private */
	/*arcane*/ private function updateScene(val:Scene3D):Void;
	/** @private */
	/*arcane*/ private function project(projectionMatrix3D:Matrix3D, ?parentSceneMatrix3D:Matrix3D):Void;
}

private typedef _Mesh =
{>_Object3D,
	/** @private */
	/*arcane*/ private var _vertexId:Int;
	/** @private */
	/*arcane*/ private var _screenVertices:Vector<Float>;
	/** @private */
	/*arcane*/ private var _uvtData:Vector<Float>;
	/** @private */
	/*arcane*/ private var _indices:Vector<Int>;
	/** @private */
	/*arcane*/ private var _triangles:GraphicsTrianglePath;
	/** @private */
	/*arcane*/ private var _faces:Vector<Face>;
	/** @private */
	/*arcane*/ private var _sort:Vector<Int>;
	/** @private */
	/*arcane*/ private var _vertices:Vector<Float>;
	/** @private */
	/*arcane*/ private var _faceMaterials:Vector<Material>;
	/*arcane */ private function buildFaces():Void;
}

private typedef _ObjectContainer3D = 
{>_Object3D,

}

private typedef _Scene3D =
{>_ObjectContainer3D,
	/*arcane*/ private var _dirtyFaces:Bool;
}

private typedef _Camera3D = {
	>_Object3D,
	/** @private */
	/*arcane*/ private var _view:View3D;
	/*arcane*/ private function update():Void;
}

private typedef _AbstractPrimitive = {
	>_Mesh,
	/** @private */
	/*arcane*/ private var _primitiveDirty:Bool;
}