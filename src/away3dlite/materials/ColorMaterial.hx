package away3dlite.materials;
import away3dlite.materials.Material;
import away3dlite.core.utils.Cast;
import away3dlite.haxeutils.FastStd;
import flash.display.BitmapData;
import webgl.wrappers.GLEnum;
#if flash9
import flash.display.GraphicsBitmapFill;
import flash.display.IGraphicsData;

#end
import flash.Lib;
import flash.Vector;


/**
 * ColorMaterial
 * @author katopz
 */
class ColorMaterial extends Material
{
	
	/**
	 * Defines the color of the material. Default value is random.

	 */
	private var _color:UInt;
	private var _wglColor:Array<Float>;
	public var color(get_color, set_color):UInt;
	private inline function get_color():UInt
	{
		return _color;
	}
	private function set_color(val:UInt):UInt
	{
		if (_color == val)
			return val;
		
		_color = val;
		#if flash9
		_graphicsBitmapFill.bitmapData = new BitmapData(2, 2, _alpha < 1, Std.int(_alpha * 0xFF) << 24 | _color);
		
		#else
		_wglColor = [((val >> 16) & 0xFF)/0xFF, ( (val >> 8) & 0xFF )/0xFF, ( val & 0xFF)/0xFF, alpha];
		
		#end
		return val;
	}
	
	/**
	 * Defines the transparency of the material. Default value is 1.

	 */
	private var _alpha:Float;
	public var alpha(get_alpha, set_alpha):Float;
	private inline function get_alpha():Float
	{
		return _alpha;
	}
	private function set_alpha(val:Float):Float
	{
		if (_alpha == val)
			return val;
		
		_alpha = val;
		
		#if flash9
		_graphicsBitmapFill.bitmapData = new BitmapData(2, 2, _alpha < 1, Std.int(_alpha * 0xFF) << 24 | _color);
		
		#else
		_wglColor[3] = alpha;
		
		#end
		return val;
	}
	
	/**
	 * Creates a new <code>BitmapMaterial</code> object.
	 * 
	 * @param	color		The color of the material.
	 * @param	alpha		The transparency of the material.
	 */
	public function new(?color:Dynamic, ?alpha:Float = 1.0)
	{
		super();

		this._color = (color != null) ? Cast.color(color) : Cast.color("random");
		this._alpha = alpha;
		_wglColor = [((_color >> 16) & 0xFF)/0xFF, ( (_color >> 8) & 0xFF )/0xFF, ( _color & 0xFF)/0xFF, alpha];
		
		#if flash9
		_graphicsBitmapFill = new GraphicsBitmapFill(new BitmapData(2, 2, _alpha < 1, Std.int(_alpha*0xFF) << 24 | _color));
		
		graphicsData = new Vector<IGraphicsData>();
		graphicsData = Lib.vectorOfArray([_graphicsStroke, _graphicsBitmapFill, _triangles, _graphicsEndFill]);
		graphicsData.fixed = true;
		
		trianglesIndex = 2;
		
		#end
	}
	
	#if !flash9
	private static var _context:ProgramContext;
	
	override private function vertexShaderSource():String
	{
		return 
		'attribute vec3 aVertexPosition;
		
		uniform mat4 uCamMatrix;
		uniform mat4 uMVMatrix;
		uniform vec4 uColor;
		
		varying vec4 vColor;
		
		void main(void) {
			gl_Position = uCamMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
			vColor = uColor;
		}';
	}
	
	override private function fragmentShaderSource():String
	{
		return
		'varying vec4 vColor;
		
		void main(void) {
		        gl_FragColor = vColor;
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
			uniformLocations.set("uColor", gl.getUniformLocation(program, "uColor"));
			
			var attribLocations = new Hash<Int>();
			
			attribLocations.set("aVertexPosition", gl.getAttribLocation(program, "aVertexPosition"));
			gl.enableVertexAttribArray(attribLocations.get("aVertexPosition"));
			
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
	}
	
	override public function updateUniforms(camera:away3dlite.cameras.Camera3D, mesh:away3dlite.core.base.Mesh, stage:jsflash.display.Stage):Void 
	{
		//var gl = stage.RenderingContext;
		gl.useProgram(context.program);
		
		gl.uniformMatrix4fv_2(context.uniformLocations.get("uCamMatrix"), false, new webgl.WebGLArray.WebGLFloatArray(stage.transform.perspectiveProjection.toMatrix3D().rawData));
		var m = mesh.sceneMatrix3D.clone();
		m.append(camera.invSceneMatrix3D);
		gl.uniformMatrix4fv_2(context.uniformLocations.get("uMVMatrix"),false, new webgl.WebGLArray.WebGLFloatArray(m.rawData));
		gl.uniform4fv(context.uniformLocations.get("uColor"), _wglColor);
	}
	
	#end
}