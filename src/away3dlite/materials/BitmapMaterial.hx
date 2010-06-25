package away3dlite.materials;
import away3dlite.materials.Material;

import flash.display.BitmapData;
import flash.display.IGraphicsData;
import flash.Lib;
import flash.Vector;
import webgl.wrappers.GLEnum;
import webgl.wrappers.WebGLObject;

/**
 * BitmapMaterial : embed image as texture
 * @author katopz
 */
class BitmapMaterial extends Material
{

	
	public var bitmap(get_bitmap, set_bitmap):BitmapData;
	private inline function get_bitmap():BitmapData
	{
		#if flash9
		return _graphicsBitmapFill.bitmapData;
		
		#else
		return bitmap;
		
		#end
	}
	private function set_bitmap(val:BitmapData):BitmapData
	{
		#if flash9
		_graphicsBitmapFill.bitmapData = val;
		
		#end
		return bitmap = val;
	}
	
		/**
		 * Defines whether repeat is used when drawing the material.

		 */
	public var repeat(get_repeat, set_repeat):Bool;
	private inline function get_repeat():Bool
	{
		#if flash9
		return _graphicsBitmapFill.repeat;
		
		#else
		return repeat;
		
		#end
	}
	private inline function set_repeat(val:Bool):Bool
	{
		#if flash9
		return _graphicsBitmapFill.repeat = val;
		
		#else
		return repeat =val;
		
		#end
	}
	
		/**
		 * Defines whether smoothing is used when drawing the material.

		 */
	public var smooth(get_smooth, set_smooth):Bool;
	private inline function get_smooth():Bool
	{
		#if flash9
		return _graphicsBitmapFill.smooth;
		
		#else
		return smooth;
		
		#end
	}
	private inline function set_smooth(val:Bool):Bool
	{
		#if flash9
		return _graphicsBitmapFill.smooth = val;
		
		#else
		return smooth = val;
		
		#end
	}
	
		/**
		 * Returns the width of the material's bitmapdata object.

		 */
	public var width(get_width, null):Int;
	private inline function get_width():Int
	{
		#if flash9
		return _graphicsBitmapFill.bitmapData.width;
		
		#else
		return width;
		
		#end
	}
		/**
		 * Returns the height of the material's bitmapdata object.
		 */
	public var height(get_height, null):Int;
	private function get_height():Int
	{
		#if flash9
		return _graphicsBitmapFill.bitmapData.height;
		
		#else
		return height;
		
		#end
	}
	
		/**
		 * Creates a new <code>BitmapMaterial</code> object.
		 * 
		 * @param	bitmap		The bitmapData object to be used as the material's texture.
		 */
	public function new(?bitmapData:BitmapData)
	{
		
		#if flash9
		_graphicsBitmapFill.bitmapData = (bitmapData != null) ? bitmapData : new BitmapData(100, 100, false, 0x000000);
		
		graphicsData = new Vector<IGraphicsData>();
		graphicsData = Lib.vectorOfArray([_graphicsStroke, _graphicsBitmapFill, _triangles, _graphicsEndFill]);
		graphicsData.fixed = true;
		
		trianglesIndex = 2;
		
		#end
		this.bitmap = bitmapData;
		currentTextureType = null;
		
		super();
	}
	
	
	#if !flash9
	private static var _context:ProgramContext;
	private static var _bitmapid:Int = 0;
	private var currentId:Int;
	
	override private function vertexShaderSource():String
	{
		return 
		'attribute vec3 aVertexPosition;
		attribute vec2 aTextureCoord;
		
		uniform mat4 uCamMatrix;
		uniform mat4 uMVMatrix;
		
		varying vec2 vTextureCoord;
		
		void main(void) {
			gl_Position = uCamMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
			vTextureCoord = aTextureCoord;
		}';
	}
	
	override private function fragmentShaderSource():String
	{
		return
		'varying vec2 vTextureCoord;
		
		uniform sampler2D uSampler;
		
		void main(void) {
		        gl_FragColor = texture2D(uSampler, vec2(vTextureCoord.s, vTextureCoord.t));
		}';
	}
	
	override public function initializeWebGL()
	{
		gl = jsflash.Manager.stage.RenderingContext;
		if (_context == null)
		{
			var vShader = gl.createShader(GLEnum.VERTEX_SHADER);
			gl.shaderSource(vShader, vertexShaderSource());
			gl.compileShader(vShader);
			
			if (!gl.getShaderParameter(vShader, GLEnum.COMPILE_STATUS))
			{
				var resp = gl.getShaderInfoLog(vShader);
				js.Lib.alert(resp);
				throw resp;
			}
			
			var fShader = gl.createShader(GLEnum.FRAGMENT_SHADER);
			gl.shaderSource(fShader, fragmentShaderSource());
			gl.compileShader(fShader);
			
			if (!gl.getShaderParameter(fShader, GLEnum.COMPILE_STATUS))
			{
				var resp = gl.getShaderInfoLog(fShader);
				js.Lib.alert(resp);
				throw resp;
			}
			
			var program = gl.createProgram();
			gl.attachShader(program, vShader);
			gl.attachShader(program, fShader);
			gl.linkProgram(program);

			if (!gl.getProgramParameter(program, GLEnum.LINK_STATUS)) 
			{
				js.Lib.alert("Could not initialise shaders");
				throw "Could not initialise shaders";
			}
			
			var uniformLocations = new Hash<webgl.wrappers.Types.WebGLUniformLocation>();
			gl.useProgram(program);
			
			uniformLocations.set("uCamMatrix", gl.getUniformLocation(program, "uCamMatrix"));
			uniformLocations.set("uMVMatrix", gl.getUniformLocation(program, "uMVMatrix"));
			uniformLocations.set("uSampler", gl.getUniformLocation(program, "uSampler"));
			
			var attribLocations = new Hash<Int>();
			
			attribLocations.set("aVertexPosition", gl.getAttribLocation(program, "aVertexPosition"));
			attribLocations.set("aTextureCoord", gl.getAttribLocation(program, "aTextureCoord"));
			gl.enableVertexAttribArray(attribLocations.get("aVertexPosition"));
			gl.enableVertexAttribArray(attribLocations.get("aTextureCoord"));
			
			context = _context = {
				vShader: vShader,
				fShader: fShader,
				program: program,
				uniformLocations: uniformLocations,
				attribLocations: attribLocations
			}
		} else {
			context = _context;
		}
		
		initTexture();
	}
	
	var tex:WebGLTexture;
	private var currentTextureType:Int;
	private function initTexture()
	{
		tex = gl.createTexture();
		if (bitmap.data.complete)
			handleLoadedTexture();
		else
			bitmap.data.onload = handleLoadedTexture;
	}
	
	private function handleLoadedTexture(?ev:js.Dom.Event):Void
	{
		gl.bindTexture(GLEnum.TEXTURE_2D, tex);
		gl.texImage2D_2(GLEnum.TEXTURE_2D, 0, bitmap.data, true);
		gl.texParameteri(GLEnum.TEXTURE_2D, GLEnum.TEXTURE_MAG_FILTER, GLEnum.LINEAR);
		gl.texParameteri(GLEnum.TEXTURE_2D, GLEnum.TEXTURE_MIN_FILTER, GLEnum.LINEAR_MIPMAP_LINEAR);
		gl.generateMipmap(GLEnum.TEXTURE_2D);
		gl.bindTexture(GLEnum.TEXTURE_2D, null);
		
		currentId = _bitmapid++;
		currentTextureType = Reflect.field(GLEnum, "TEXTURE" + currentId);
	}
	
	override public function renderMesh(mesh:away3dlite.core.base.Mesh, camera:away3dlite.cameras.Camera3D, stage:jsflash.display.Stage):Void 
	{
		if (mesh.indicesBuffer == null || mesh.verticesBuffer == null)
			return;
		//var gl = stage.RenderingContext;
		gl.useProgram(context.program);
		
		updateUniforms(camera, mesh, stage);
		
		gl.bindBuffer(GLEnum.ARRAY_BUFFER, mesh.verticesBuffer);
		gl.vertexAttribPointer(context.attribLocations.get("aVertexPosition"), 3, GLEnum.FLOAT, false, 0, 0);
		
		gl.bindBuffer(GLEnum.ARRAY_BUFFER, mesh.stBuffer);
		gl.vertexAttribPointer(context.attribLocations.get("aTextureCoord"), 2, GLEnum.FLOAT, false, 0, 0);
		
		gl.bindBuffer(GLEnum.ELEMENT_ARRAY_BUFFER, mesh.indicesBuffer);
		gl.drawElements(GLEnum.TRIANGLES, mesh.numItems, GLEnum.UNSIGNED_SHORT, 0);
		
	}
	
	override public function updateUniforms(camera:away3dlite.cameras.Camera3D, mesh:away3dlite.core.base.Mesh, stage:jsflash.display.Stage):Void 
	{
		if (currentTextureType == null)
			return;
		//var gl = stage.RenderingContext;
		gl.useProgram(context.program);
		
		gl.uniformMatrix4fv_2(context.uniformLocations.get("uCamMatrix"), false, new webgl.WebGLArray.WebGLFloatArray(stage.transform.perspectiveProjection.toMatrix3D().rawData));
		var m = mesh.sceneMatrix3D.clone();
		m.append(camera.invSceneMatrix3D);
		gl.uniformMatrix4fv_2(context.uniformLocations.get("uMVMatrix"), false, new webgl.WebGLArray.WebGLFloatArray(m.rawData));
		
		gl.activeTexture(currentTextureType);
		gl.bindTexture(GLEnum.TEXTURE_2D, tex);
		gl.uniform1i(context.uniformLocations.get("uSampler"), 0);

	}
	
	#end
}