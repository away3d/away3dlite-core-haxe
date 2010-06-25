package away3dlite.materials;

import away3dlite.containers.Scene3D;
import away3dlite.events.MaterialEvent;
import jsflash.geom.Matrix3D;
import jsflash.geom.PerspectiveProjection;
import jsflash.Manager;
import webgl.wrappers.GLEnum;
import webgl.wrappers.WebGLRenderingContext;
#if flash9
import flash.display.GraphicsBitmapFill;
import flash.display.GraphicsEndFill;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.GraphicsTrianglePath;
import flash.display.IGraphicsData;

#end
import flash.events.EventDispatcher;
import flash.Vector;

using away3dlite.namespace.Arcane;

/**
 * Dispatched when the material becomes visible in a view.
 * 
 * @eventType away3dlite.events.MaterialEvent
 */
//[Event(name="materialActivated",type="away3dlite.events.MaterialEvent")]
			
/**
 * Dispatched when the material becomes invisible in a view.
 * 
 * @eventType away3dlite.events.MaterialEvent
 */
//[Event(name="materialDeactivated",type="away3dlite.events.MaterialEvent")]


/**
 * Base material class.
 */	
class Material extends EventDispatcher
{
	/** @private */
	/*arcane*/ private var _id:Vector<UInt>;
	/** @private */
	/*arcane*/ private var _faceCount:Vector<UInt>;
	/** @private */
	/*arcane*/ private function notifyActivate(scene:Scene3D):Void
	{
		if (!hasEventListener(MaterialEvent.MATERIAL_ACTIVATED))
			return;
		
		if (_materialactivated == null)
			_materialactivated = new MaterialEvent(MaterialEvent.MATERIAL_ACTIVATED, this);
			
		dispatchEvent(_materialactivated);
	}
	/** @private */
	/*arcane*/ private function notifyDeactivate(scene:Scene3D):Void
	{
		if (!hasEventListener(MaterialEvent.MATERIAL_DEACTIVATED))
			return;
		
		if (_materialdeactivated == null)
			_materialdeactivated = new MaterialEvent(MaterialEvent.MATERIAL_DEACTIVATED, this);
			
		dispatchEvent(_materialdeactivated);
	}
	
	#if flash9
	private static var DEBUG_STROKE:GraphicsStroke = new GraphicsStroke(1, false, "normal", "none", "round", 0, new GraphicsSolidFill(0xFF00FF));
	
	#end
	private var _debug:Bool;
	private var _materialactivated:MaterialEvent;
	private var _materialdeactivated:MaterialEvent;
	
	#if flash9
	/** @private */
	private var _graphicsStroke:GraphicsStroke;
	/** @private */
	private var _graphicsBitmapFill:GraphicsBitmapFill;
	/** @private */
	private var _graphicsEndFill:GraphicsEndFill;
	/** @private */
	private var _triangles:GraphicsTrianglePath;
	/** @private */
	public var graphicsData:Vector<IGraphicsData>;
	/** @private */
	public var trianglesIndex:Int;
	
	#end
	/**
	 * Creates a new <code>Material</code> object.
	 */
	public function new() 
	{
		super();
		
		_id = new Vector<UInt>();
		_faceCount = new Vector<UInt>();
		
		_debug = false;
		#if flash9
		_graphicsStroke = new GraphicsStroke();
		_graphicsBitmapFill = new GraphicsBitmapFill();
		_graphicsEndFill = new GraphicsEndFill();
		
		#else
		initializeWebGL();
		
		#end
		
		
	}
	
	/**
	 * Switches on the debug outlines around each face drawn with the material. Defaults to false.
	 */
	public var debug(get_debug, set_debug):Bool;
	private function get_debug():Bool
	{
		return _debug;
	}
	private function set_debug(val:Bool):Bool
	{
		if (_debug == val)
			return val;
			
		_debug = val;
		#if flash9
		graphicsData.fixed = false;
		
		if(_debug) {
			graphicsData.shift();
			graphicsData.unshift(DEBUG_STROKE);
		} else {
			graphicsData.shift();
			graphicsData.unshift(_graphicsStroke);
		}
		
		graphicsData.fixed = true;
		#end
		return val;
	}
	
	#if !flash9
	private static var _context:ProgramContext;
	public var context:ProgramContext;
	
	private function vertexShaderSource():String
	{
		return 
		'attribute vec3 aVertexPosition;
		
		uniform mat4 uCamMatrix;
		uniform mat4 uMVMatrix;
		
		void main(void) {
			gl_Position = uCamMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
		}';
	}
	
	private function fragmentShaderSource():String
	{
		return
		'void main(void) {
		        gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
		}';
	}
	
	public function initializeWebGL()
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
	
	public function renderMesh(mesh:away3dlite.core.base.Mesh, camera:away3dlite.cameras.Camera3D, stage:jsflash.display.Stage):Void 
	{
		if (mesh.indicesBuffer == null || mesh.verticesBuffer == null)
			return;
		//var gl = stage.RenderingContext;
		gl.useProgram(context.program);
		
		updateUniforms(camera, mesh, stage);
		
		gl.bindBuffer(GLEnum.ARRAY_BUFFER, mesh.verticesBuffer);
		gl.vertexAttribPointer(context.attribLocations.get("aVertexPosition"), 3, GLEnum.FLOAT, false, 0,0);
		
		gl.bindBuffer(GLEnum.ELEMENT_ARRAY_BUFFER, mesh.indicesBuffer);
		gl.drawElements(GLEnum.TRIANGLES, mesh.numItems, GLEnum.UNSIGNED_SHORT, 0);
		
	}
	
	private var gl:WebGLRenderingContext;
	
	public function updateUniforms(camera:away3dlite.cameras.Camera3D, mesh:away3dlite.core.base.Mesh, stage:jsflash.display.Stage):Void 
	{
		//var gl = stage.RenderingContext;
		gl.useProgram(context.program);
		
		gl.uniformMatrix4fv_2(context.uniformLocations.get("uCamMatrix"), false, new webgl.WebGLArray.WebGLFloatArray(stage.transform.perspectiveProjection.toMatrix3D().rawData));
		var m = mesh.sceneMatrix3D.clone();
		m.append(camera.invSceneMatrix3D);
		gl.uniformMatrix4fv_2(context.uniformLocations.get("uMVMatrix"),false, new webgl.WebGLArray.WebGLFloatArray(m.rawData));
	}
	
	#end
}

#if !flash9
typedef ProgramContext = {
	var program:webgl.wrappers.WebGLObject.WebGLProgram;
	var vShader:webgl.wrappers.WebGLObject.WebGLShader;
	var fShader:webgl.wrappers.WebGLObject.WebGLShader;
	var uniformLocations:Hash<webgl.wrappers.Types.WebGLUniformLocation>;
	var attribLocations:Hash<webgl.wrappers.Types.GLint>;
}

#end