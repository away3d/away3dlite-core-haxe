/**
 * haXe package to emulate arcane namespace access. Should be used with the using keyword.
 * @author waneck
 */

package away3dlite.namespace;

#if (haxe_205 && flash9) extern #end class _AbstractLight3DArcane
{
	public static inline function arcaneNS(obj : away3dlite.lights.AbstractLight3D) : _AbstractLight3D
	{
		return obj;
	}
}

#if (haxe_205 && flash9) extern #end class _AbstractLensArcane
{
	public static inline function arcaneNS(obj : away3dlite.cameras.lenses.AbstractLens) : _AbstractLens
	{
		return obj;
	}
}

#if (haxe_205 && flash9) extern #end class _MaterialArcane
{
	public static inline function arcaneNS(obj : away3dlite.materials.Material) : _Material
	{
		return obj;
	}
}

#if (haxe_205 && flash9) extern #end class _Sprite3DArcane
{
	public static inline function arcaneNS(obj : away3dlite.sprites.Sprite3D) : _Sprite3D
	{
		return obj;
	}
}

#if (haxe_205 && flash9) extern #end class _RendererArcane
{
	public static inline function arcaneNS(obj : away3dlite.core.render.Renderer) : _Renderer
	{
		return obj;
	}
}

#if (haxe_205 && flash9) extern #end class _ClippingArcane
{
	public static inline function arcaneNS(obj : away3dlite.core.clip.Clipping) : _Clipping
	{
		return obj;
	}
	
	public static inline function arcane_ns(obj : away3dlite.core.clip.Clipping) : _Clipping
	{
		return obj;
	}
}

#if (haxe_205 && flash9) extern #end class _View3DArcane
{
	public static inline function arcaneNS(obj : away3dlite.containers.View3D) : _View3D
	{
		return obj;
	}
}

#if (haxe_205 && flash9) extern #end class _AbstractPrimitiveArcane
{
	public static inline function arcaneNS(obj : away3dlite.loaders.AbstractParser) : _AbstractParser
	{
		return obj;
	}
}

#if (haxe_205 && flash9) extern #end class _Camera3DArcane
{
	public static inline function arcaneNS(obj : away3dlite.cameras.Camera3D) : _Camera3D
	{
		return obj;
	}
	
	public static inline function arcane_ns	(obj : away3dlite.cameras.Camera3D) : _Camera3D
	{
		return obj;
	}
}

#if (haxe_205 && flash9) extern #end class _AbstractParserArcane
{
	public static inline function arcaneNS(obj : away3dlite.loaders.AbstractParser) : _AbstractParser
	{
		return obj;
	}
}

#if (haxe_205 && flash9) extern #end class _Scene3DArcane
{
	public static inline function arcaneNS(obj : away3dlite.containers.Scene3D) : _Scene3D
	{
		return obj;
	}
	
	public static inline function arcane_ns(obj : away3dlite.containers.Scene3D) : _Scene3D
	{
		return obj;
	}
}

#if (haxe_205 && flash9) extern #end class _ObjectContainer3DArcane
{
	public static inline function arcaneNS(obj : away3dlite.containers.ObjectContainer3D) : _ObjectContainer3D
	{
		return obj;
	}
}

#if (haxe_205 && flash9) extern #end class _MeshArcane
{
	public static inline function arcaneNS(obj : away3dlite.core.base.Mesh) : _Mesh
	{
		return obj;
	}
	
	public static inline function arcane_ns(obj : away3dlite.core.base.Mesh) : _Mesh
	{
		return obj;
	}
}

#if (haxe_205 && flash9) extern #end class _Object3DArcane
{
	public static inline function arcaneNS(obj : away3dlite.core.base.Object3D) : _Object3D
	{
		return obj;
	}
}



import away3dlite.cameras.Camera3D;
import away3dlite.cameras.lenses.AbstractLens;
import away3dlite.containers.Scene3D;
import away3dlite.containers.View3D;
import away3dlite.core.base.Mesh;
import away3dlite.core.clip.Clipping;
import away3dlite.events.ParserEvent;
import away3dlite.lights.AbstractLight3D;
import away3dlite.materials.Material;
import flash.display.DisplayObject;
import flash.display.GraphicsTrianglePath;
import flash.display.Sprite;
import flash.geom.Matrix3D;
import away3dlite.core.base.Face;
import flash.Vector;
import flash.display.TriangleCulling;

private typedef _AbstractLight3D = {
	/** @private */
	/*arcane*/ private var _red:Float;
	/** @private */
	/*arcane*/ private var _green:Float;
	/** @private */
	/*arcane*/ private var _blue:Float;
	/** @private */
	/*arcane*/ private var _camera:Camera3D;
}

private typedef _AbstractLens = {
	/** @private */
	/**arcane**/ private var _view:View3D;
	/** @private */
	/**arcane**/ private var _root:DisplayObject;
	/** @private */
	/**arcane**/ private var _camera:Camera3D;
	/** @private */
	/**arcane**/ private var _projectionMatrix3D:Matrix3D;		
	/** @private */
	/**arcane**/ private function _update():Void;
}

private typedef _Material = {
	/** @private */
	/*arcane*/ private var _id:Vector<UInt>;
	/** @private */
	/*arcane*/ private var _faceCount:Vector<UInt>;
	/** @private */
	/*arcane*/ private function notifyActivate(scene:Scene3D):Void;
	/** @private */
	/*arcane*/ private function notifyDeactivate(scene:Scene3D):Void;
	/** @private */
	/*arcane*/ private function updateMaterial(source:Mesh, camera:Camera3D):Void;
}

private typedef _Sprite3D = {
	/** @private */
	/*arcane*/ private var index:Int;
	/** @private */
	/*arcane*/ private var indices:Vector<Int>;
	/** @private */
	/*arcane*/ private var uvtData:Vector<Float>;
}

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
	/*arcane*/ private var _perspCulling:Bool;
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
	/*arcane*/ private function project(camera:Camera3D, ?parentSceneMatrix3D:Matrix3D):Void;
}

private typedef _Mesh =
{>_Object3D,
	/** @private */
	/*arcane*/ private var _materialsDirty:Bool;
	/** @private */
	/*arcane*/ private var _materialsCacheList:Vector<Material>;
	/** @private */
	/*arcane*/ private var _vertexId:Int;
	/** @private */
	/*arcane*/ private var _screenVertices:Vector<Float>;
	/** @private */
	/*arcane*/ private var _uvtData:Vector<Float>;
	/** @private */
	/*arcane*/ private var _indices:Vector<Int>;
	/** @private */
	/*arcane*/ private var _indicesTotal:Int;
	/** @private */
	/*arcane*/ private var _culling:TriangleCulling;
	/** @private */
	/*arcane*/ private var _faces:Vector<Face>;
	/** @private */
	/*arcane*/ private var _faceLengths:Vector<Int>;
	/** @private */
	/*arcane*/ private var _sort:Vector<Int>;
	/** @private */
	/*arcane*/ private var _vertices:Vector<Float>;
	/** @private */
	/*arcane*/ private var _faceMaterials:Vector<Material>;
	/** @private */	
	/*arcane*/ private function buildFaces():Void;
}

private typedef _ObjectContainer3D = 
{>_Object3D,

}

private typedef _Scene3D =
{>_ObjectContainer3D,
	/*arcane*/ private var _id:UInt;
	/** @private */
	/*arcane*/ private var _broadcaster:Sprite;
	/** @private */
	/*arcane*/ private var _materialsSceneList:Vector<Material>;
	/** @private */
	/*arcane*/ private var _materialsPreviousList:Vector<Material>;
	/** @private */
	/*arcane*/ private var _materialsNextList:Vector<Material>;
	/** @private */
	/*arcane*/ private var _sceneLights:Vector<AbstractLight3D>;
	/** @private */
	/*arcane*/ private function removeSceneMaterial(mat:Material):Void;
	/** @private */
	/*arcane*/ private function addSceneMaterial(mat:Material):Void;
	/** @private */
	/*arcane*/ private function addSceneLight(light:AbstractLight3D):Void;
	/** @private */
	/*arcane*/ private function removeSceneLight(light:AbstractLight3D):Void;
}

private typedef _Camera3D = {
	>_Object3D,
	/** @private */
	/*arcane*/ private var _view:View3D;
	/** @private */
	/*arcane*/ private var _lens:AbstractLens;
	/*arcane*/ private var _invSceneMatrix3D:Matrix3D;
	/*arcane*/ private var _projectionMatrix3D:Matrix3D;
	/*arcane*/ private var _screenMatrix3D:Matrix3D;
	
	/*arcane*/ private function update():Void;
}

private typedef _AbstractPrimitive = {
	>_Mesh,
	/** @private */
	/*arcane*/ private var _primitiveDirty:Bool;
}