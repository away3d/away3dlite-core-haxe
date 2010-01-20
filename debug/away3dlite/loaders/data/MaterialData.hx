package away3dlite.loaders.data;

import away3dlite.core.base.Face;
import away3dlite.core.base.Mesh;
import away3dlite.core.base.Object3D;
import away3dlite.haxeutils.FastStd;
import away3dlite.materials.BitmapMaterial;
import away3dlite.materials.Material;
import flash.display.BitmapData;
import flash.Lib;
import flash.Vector;

//use namespace arcane;
using away3dlite.namespace.Arcane;
using away3dlite.haxeutils.HaxeUtils;

/**
 * Data class for the material data of a face.
 * 
 * @see away3dlite.loaders.data.FaceData
 */
class MaterialData
{
	private var _material:Material;
	
	/**
	 * String representing a texture material.
	 */
	public static inline var TEXTURE_MATERIAL:String = "textureMaterial";
	
	/**
	 * String representing a shaded material.
	 */
	public static inline var SHADING_MATERIAL:String = "shadingMaterial";
	
	/**
	 * String representing a color material.
	 */
	public static inline var COLOR_MATERIAL:String = "colorMaterial";
	
	/**
	 * String representing a wireframe material.
	 */
	public static inline var WIREFRAME_MATERIAL:String = "wireframeMaterial";
	
	/**
	 * The name of the material used as a unique reference.
	 */
	public var name:String;
	
	/**
	 * Optional alpha of the material.
	 */
	public var alpha:Float;
	
	/**
	 * Optional ambient color of the material.
	 */
	public var ambientColor:UInt;
	
	/**
	 * Optional diffuse color of the material.
	 */
	public var diffuseColor:UInt;
	
	/**
	 * Optional specular color of the material.
	 */
	public var specularColor:UInt;
	
	/**
	 * Optional shininess of the material.
	 */
	public var shininess:Float;
	
	/**
	 * Reference to the filename of the texture image.
	 */
	public var textureFileName:String;
	
	/**
	 * Reference to the bitmapData object of the texture image.
	 */
	public var textureBitmap:BitmapData;
	
	/**
	 * defines the material object of the resulting material.
	 */
	public var material(get_material, set_material):Material;
	private inline function get_material():Material
	{
		return _material;
	}
	
	private function set_material(val:Material):Material
	{
		if (_material == val)
			return val;
		
		_material = val;

		if (FastStd.is(_material, BitmapMaterial))
			textureBitmap = _material.downcast(BitmapMaterial).bitmap;
		
		//var mesh:Mesh;
		for (mesh in meshes)
			mesh.material = _material;
		
		//var face:Face;
		
		for (face in faces)
		{
			face.mesh.arcaneNS()._faceMaterials[face.faceIndex] = _material;
			face.mesh.arcaneNS()._materialsDirty = true;
		}
		return val;
	}
			
	/**
	 * String representing the material type.
	 */
	public var materialType:String;
	
	/**
	 * Array of indexes representing the elements that use the material.
	 */
	public var faces:Vector<Face>;
	
	/**
	 * Array of indexes representing the meshes that use the material.
	 */
	public var meshes:Vector<Mesh>;
	
	public function new()
	{
		materialType = WIREFRAME_MATERIAL;
		faces = new Vector<Face>();
		meshes = new Vector<Mesh>();
		materialType = WIREFRAME_MATERIAL;
	}
	
	public function clone(targetObj:Object3D):MaterialData
	{
		var cloneMatData:MaterialData = targetObj.materialLibrary.addMaterial(name);

		cloneMatData.materialType = materialType;
		cloneMatData.ambientColor = ambientColor;
		cloneMatData.diffuseColor = diffuseColor;
		cloneMatData.shininess = shininess;
		cloneMatData.specularColor = specularColor;
		cloneMatData.textureBitmap = textureBitmap;
		cloneMatData.textureFileName = textureFileName;
		cloneMatData.material = material;
		/*
		for each(var element:Element in elements)
		{
			var parentGeometry:Geometry = element.parent;
			var correspondingElement:Element = parentGeometry.cloneElementDictionary[element];
			cloneMatData.elements.push(correspondingElement);
		}
		*/
		return cloneMatData;
	}
}