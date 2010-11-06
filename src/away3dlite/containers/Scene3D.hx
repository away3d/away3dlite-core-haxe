package away3dlite.containers;

import away3dlite.cameras.Camera3D;
import away3dlite.core.base.Object3D;
import away3dlite.lights.AbstractLight3D;
import away3dlite.materials.Material;
import flash.display.Sprite;
import flash.geom.Matrix3D;
import flash.Vector;

//use namespace arcane;
using away3dlite.namespace.Arcane;

/**
* The root container of all 3d objects in a single scene
*/
class Scene3D extends ObjectContainer3D
{
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
	/*arcane*/ private function removeSceneMaterial(mat:Material):Void
	{
		
		if ((--mat.arcaneNS()._faceCount[_id] == 0)) {
			
			_materialsSceneList[mat.arcaneNS()._id[_id]] = null;
			
			//reduce the length of the material list if the removed material is at the end
			if (mat.arcaneNS()._id[_id] == cast _materialsSceneList.length - 1) {
				_materialsSceneList.length--;
				_materialsNextList.length--;
			}
		}
	}
	/** @private */
	/*arcane*/ private function addSceneMaterial(mat:Material):Void
	{
		if (mat.arcaneNS()._faceCount.length <= _id)
			mat.arcaneNS()._id.length = mat.arcaneNS()._faceCount.length = _id + 1;
		
		if (mat.arcaneNS()._faceCount[_id] == 0) {
			
			var i:UInt = 0;
			var length:UInt = _materialsSceneList.length;
			while (i < length) {
				//add the material to the first available space
				if (_materialsSceneList[i] == null) {
					_materialsSceneList[mat.arcaneNS()._id[_id] = i] = mat;
					break;
				} else {
					i++;
				}
			}
			//increase the length of the material list if the added material is at the end
			if (i == length) {
				_materialsSceneList.length++;
				_materialsNextList.length++;
				_materialsSceneList[mat.arcaneNS()._id[_id] = i] = mat;
			}
		}
		//this in above conditional causes flex java error
		mat.arcaneNS()._faceCount[_id]++;
	}
	/** @private */
	/*arcane*/ private function addSceneLight(light:AbstractLight3D):Void
	{
		_sceneLights[_sceneLights.length] = light;
	}
	/** @private */
	/*arcane*/ private function removeSceneLight(light:AbstractLight3D):Void
	{
		_index = _sceneLights.indexOf(light);
		
		if (_index != -1)
			_sceneLights.splice(_index, 1);
	}
	
	/** @private */
	/*arcane*/ private override function project(camera:Camera3D, ?parentSceneMatrix3D:Matrix3D):Void
	{
		_materialsNextList = new Vector<Material>(_materialsNextList.length);
		
		super.project(camera, parentSceneMatrix3D);
		
		var i:UInt;
		var matPrevious:Material;
		var matNext:Material;
		
		if (_materialsPreviousList.length > _materialsNextList.length)
			i = _materialsNextList.length = _materialsPreviousList.length;
		else
			i = _materialsPreviousList.length = _materialsNextList.length;
		
		while (i-- != 0) {
			matPrevious = _materialsPreviousList[i];
			matNext = _materialsNextList[i];
			if (matPrevious != matNext) {
				if (matPrevious != null)
					matPrevious.arcaneNS().notifyDeactivate(this);
				if (matNext != null)
					matNext.arcaneNS().notifyActivate(this);
			}
		}
		
		_materialsPreviousList = _materialsNextList;
	}
	
	private static var _idTotal:UInt = 0;
	
	/**
	* Returns the lights of the scene as an array of 3d lights.
	*/
	public inline var sceneLights(get_sceneLights, never):Vector<AbstractLight3D>;
	private inline function get_sceneLights():Vector<AbstractLight3D>
	{
		return _sceneLights;
	}
	
	/**
	 * Creates a new <code>Scene3D</code> object
	 * 
	 * @param	...childArray		An array of 3d objects to be added as children of the container on instatiation. Can contain an initialisation object
	 */
	public function new(?childArray:Array<Object3D>)
	{
		_id = _idTotal++;
		
		super();
		
		_broadcaster = new Sprite();

		_materialsSceneList = new Vector<Material>();
		_materialsPreviousList = new Vector<Material>();
		_materialsNextList = new Vector<Material>();
		_sceneLights = new Vector<AbstractLight3D>();
		
		if (childArray != null)
			for (child in childArray)
				addChild(child);
		
		_scene = this;
	}
}