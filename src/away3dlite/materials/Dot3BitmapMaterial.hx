package away3dlite.materials;
import away3dlite.cameras.Camera3D;
import away3dlite.core.base.Mesh;
import away3dlite.lights.AbstractLight3D;
import away3dlite.lights.DirectionalLight3D;
import away3dlite.lights.PointLight3D;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.Shader;
import flash.display.ShaderJob;
import flash.filters.ShaderFilter;
import flash.geom.Matrix3D;
import flash.geom.Point;
import flash.Lib;
import flash.Vector;
import haxe.io.BytesData;


//use namespace arcane;
using away3dlite.namespace.Arcane;

/**
 * Bitmap material with DOT3 shading.
 */
class Dot3BitmapMaterial extends BitmapMaterial
{
	private var _shaderJob:ShaderJob;
	private var _shaderBlendMode:String;
	private var _lightMap:BitmapData;
	private var _bitmap:BitmapData;
	private var _shininess:Float;
	private var _specular:Float;
	private var _normalMap:BitmapData;
	private var _normalVector:Vector<Float>;
	private var _normalShader:Shader;
	private var _normalFilter:ShaderFilter;
	private var _light:AbstractLight3D;
	private var _directionalLight:DirectionalLight3D;
	private var _pointLight:PointLight3D;
	private var _zeroPoint:Point;
	private var _positionMapDirty:Bool;
	private var _positionVector:Vector<Float>;
	
	//[Embed(source="../../../pbj/normalMapping.pbj",mimeType="application/octet-stream")]
	//private var NormalShader:Class;
	
	/*arcane*/ private override function updateMaterial(source:Mesh, camera:Camera3D):Void
	{
		_lightMap.fillRect(_lightMap.rect, 0);
		
		for (i in 0...source.scene.sceneLights.length) {
			var _light = source.scene.sceneLights[i];
			if ((_directionalLight = Lib.as(_light, DirectionalLight3D)) != null) {
				var _red:Float = _directionalLight.arcaneNS()._red*_directionalLight.diffuse;
				var _green:Float = _directionalLight.arcaneNS()._green*_directionalLight.diffuse;
				var _blue:Float = _directionalLight.arcaneNS()._blue*_directionalLight.diffuse;
				
				var diffuseTransform:Matrix3D = _directionalLight.diffuseTransform.clone();
				diffuseTransform.prepend(source.sceneMatrix3D);
				var diffuseRawData:Vector<Float> = diffuseTransform.rawData;
				
				var _szx:Float = diffuseRawData[2];
				var _szy:Float = diffuseRawData[6];
				var _szz:Float = -diffuseRawData[10];
				
				var mod:Float = Math.sqrt(_szx*_szx + _szy*_szy + _szz*_szz);
				
				_szx /= mod;
				_szy /= mod;
				_szz /= mod;
				
				_normalShader.data.diffuseMatrixR.value = [_red*_szx, _green*_szx, _blue*_szx, 0];
				_normalShader.data.diffuseMatrixG.value = [_red*_szy, _green*_szy, _blue*_szy, 0];
				_normalShader.data.diffuseMatrixB.value = [_red*_szz, _green*_szz, _blue*_szz, 0];
				_normalShader.data.diffuseMatrixO.value = [-_red*(_szx + _szy + _szz)/2, -_green*(_szx + _szy + _szz)/2, -_blue*(_szx + _szy + _szz)/2, 1];
				_normalShader.data.ambientMatrixO.value = [_directionalLight.arcaneNS()._red*_directionalLight.ambient, _directionalLight.arcaneNS()._green*_directionalLight.ambient, _directionalLight.arcaneNS()._blue*_directionalLight.ambient, 1];
				
				
				_red = (_directionalLight.arcaneNS()._red + _shininess)*_specular*2;
				_green = (_directionalLight.arcaneNS()._green + _shininess)*_specular*2;
				_blue = (_directionalLight.arcaneNS()._blue + _shininess)*_specular*2;
				
				var specularTransform:Matrix3D = _directionalLight.specularTransform.clone();
				specularTransform.prepend(source.sceneMatrix3D);
				var specularRawData:Vector<Float> = specularTransform.rawData;
				
				_szx = specularRawData[2];
				_szy = specularRawData[6];
				_szz = -specularRawData[10];
				
				_normalShader.data.specularMatrixR.value = [_red*_szx, _green*_szx, _blue*_szx, 0];
				_normalShader.data.specularMatrixG.value = [_red*_szy, _green*_szy, _blue*_szy, 0];
				_normalShader.data.specularMatrixB.value = [_red*_szz, _green*_szz, _blue*_szz, 0];
				_normalShader.data.specularMatrixO.value = [-_red*(_szx + _szy + _szz)/2 -shininess*specular, -_green*(_szx + _szy + _szz)/2 -shininess*specular, -_blue*(_szx + _szy + _szz)/2 -shininess*specular, 1];
				_normalShader.data.lightMap.input = _lightMap;
				
				_shaderJob = new ShaderJob(_normalShader, _lightMap);
				_shaderJob.start(true);
			} else if ((_pointLight = Lib.as(_light, PointLight3D)) != null) {
				
				if (_positionMapDirty) {
					_positionMapDirty = false;
				}
			}
		}
		
		_graphicsBitmapFill.bitmapData = _bitmap.clone();
		_graphicsBitmapFill.bitmapData.draw(_lightMap, null, null, cast _shaderBlendMode);
		//_graphicsBitmapFill.bitmapData.applyFilter(_bitmap, bitmap.rect, _zeroPoint, _normalFilter);
		
		super.updateMaterial(source, camera);
	}
	
	/**
	 * The exponential dropoff value used for specular highlights.
	 */
	public var shininess(get_shininess, set_shininess):Float;
	private inline function get_shininess():Float
	{
		return _shininess;
	}
	
	private inline function set_shininess(val:Float):Float
	{
		return _shininess = val;
	}
	
	/**
	 * Coefficient for specular light level.
	 */
	public var specular(get_specular, set_specular):Float;
	private inline function get_specular():Float
	{
		return _specular;
	}
	
	private inline function set_specular(val:Float):Float
	{
		return _specular = val;
	}
	
	/**
	* Returns the bitmapData object being used as the material normal map.
	*/
	public var normalMap(get_normalMap, never):BitmapData;
	private inline function get_normalMap():BitmapData
	{
		return _normalMap;
	}
	
	/**
	 * Creates a new <code>Dot3BitmapMaterial</code> object.
	 * 
	 * @param	bitmap				The bitmapData object to be used as the material's texture.
	 * @param	normalMap			The bitmapData object to be used as the material's DOT3 map.
	 * @param	init	[optional]	An initialisation object for specifying default instance properties.
	 */
	public function new(bitmap:BitmapData, normalMap:BitmapData)
	{
		super(bitmap);
		_shaderBlendMode = cast BlendMode.HARDLIGHT;
		_zeroPoint = new Point();
		_shininess = 20;
		_specular = 0.7;
		
		_lightMap = bitmap.clone();
		_bitmap = bitmap;
		
		_normalMap = normalMap;
		_normalVector = new Vector<Float>(_normalMap.width*_normalMap.height*4);
		var w:Int = _normalMap.width;
		var h:Int = _normalMap.height;
		
		var i:Int = h;
		var j:Int;
		var pixel:Int;
		var pixelValue:Int;
		var rValue:Float;
		var gValue:Float;
		var bValue:Float;
		var mod:Float;
		
		//normalise map
		while (i-- > 0) {
			j = w;
			while (j-- > 0) {
				//get values
				pixelValue = _normalMap.getPixel32(j, i);
				rValue = ((pixelValue & 0x00FF0000) >> 16)- 127;
				gValue = ((pixelValue & 0x0000FF00) >> 8) - 127;
				bValue = ((pixelValue & 0x000000FF)) - 127;
				
				//calculate modulus
				mod = Math.sqrt(rValue*rValue + gValue*gValue + bValue*bValue)*2;
				
				//set normalised values
				pixel = i*w*4 + j*4;
				_normalVector[pixel]     = rValue/mod + 0.5;
				_normalVector[pixel + 1] = gValue/mod + 0.5;
				_normalVector[pixel + 2] = bValue/mod + 0.5;
				_normalVector[pixel + 3] = 1;
			}
		}
		
		_normalShader = new Shader(NormalShader.SHADER_BYTES);
		
		_normalShader.data.normalMap.width = w;
		_normalShader.data.normalMap.height = h;
		_normalShader.data.normalMap.input = _normalVector;
		
		_normalFilter = new ShaderFilter(_normalShader);
	}
}

private class NormalShader
{
	public static var SHADER_BYTES:BytesData = haxe.Unserializer.run("s1075:pQEAAACkDQBub3JtYWxNYXBwaW5noAxuYW1lc3BhY2UAQUlGAKAMdmVuZG9yAEFkb2JlIFN5c3RlbXMsIEluYy4AoAh2ZXJzaW9uAAIAoAxkZXNjcmlwdGlvbgBub3JtYWxNYXBwaW5nAKEBAgAADF9PdXRDb29yZAChAQQBAA9kaWZmdXNlTWF0cml4UgChAQQCAA9kaWZmdXNlTWF0cml4RwChAQQDAA9kaWZmdXNlTWF0cml4QgChAQQEAA9kaWZmdXNlTWF0cml4TwChAQQFAA9hbWJpZW50TWF0cml4TwChAQQGAA9zcGVjdWxhck1hdHJpeFIAoQEEBwAPc3BlY3VsYXJNYXRyaXhHAKEBBAgAD3NwZWN1bGFyTWF0cml4QgChAQQJAA9zcGVjdWxhck1hdHJpeE8AowAEbGlnaHRNYXAAowEEbm9ybWFsTWFwAKECBAoAD2RzdAAwCwDxAAAQAB0MAPMLABsAMAsA8QAAEAEdDQDzCwAbAB0LAPMNAAAAAwsA8wEAGwAdDgDzDQBVAAMOAPMCABsAHQ8A8wsAGwABDwDzDgAbAB0LAPMNAKoAAwsA8wMAGwAdDgDzDwAbAAEOAPMLABsAHQsA8w4AGwABCwDzBAAbADIOAIAAAAAAMg4AQAAAAAAyDgAgAAAAADIOABAAAAAAHQ8A8wsAGwAKDwDzDgAbAB0LAPMPABsAAQsA8wUAGwAdDgDzCwAbAB0LAPMNAAAAAwsA8wYAGwAdDwDzDQBVAAMPAPMHABsAHRAA8wsAGwABEADzDwAbAB0LAPMNAKoAAwsA8wgAGwAdDwDzEAAbAAEPAPMLABsAHQsA8w8AGwABCwDzCQAbAB0PAPMLABsAMAsA8QAAEAAdEADzCwAbAAEQAPMOABsAHQsA8w8AGwAyEQCAAAAAADIRAEAAAAAAMhEAIAAAAAAyEQAQAAAAADISAIA:gAAAMhIAQD%AAAAyEgAgP4AAADISABA:gAAAHRMA8wsAGwAKEwDzEQAbAB0UAPMTABsACRQA8xIAGwAdCwDzEAAbAAELAPMTABsAHQoA8wsAGwA").getData();
}