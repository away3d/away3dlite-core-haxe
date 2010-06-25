package away3dlite.materials;
import away3dlite.core.utils.Cast;
import webgl.wrappers.GLEnum;
#if flash9
import flash.display.GraphicsSolidFill;

#end
import flash.Lib;

using away3dlite.haxeutils.HaxeUtils;

/**
 * ColorMaterial
 * @author katopz
 */
class WireColorMaterial extends ColorMaterial
{
	
	/**

	 * Defines the color of the outline.
	 */
	private var _wireColor:UInt;
	public var wireColor(get_wireColor, set_wireColor):UInt;
	private inline function get_wireColor():UInt
	{
		return _wireColor;
	}
	private function set_wireColor(val:UInt):UInt
	{
		if (_wireColor == val)
			return val;
		
		_wireColor = val;
		
		#if flash9
		_graphicsStroke.fill.downcast(GraphicsSolidFill).color = _wireColor;
		
		#end
		return val;
	}
	
	/**

	 * Defines the transparency of the outline.
	 */
	private var _wireAlpha:Float;
	public var wireAlpha(get_wireAlpha, set_wireAlpha):Float;
	private inline function get_wireAlpha():Float
	{
		return _wireAlpha;
	}
	private function set_wireAlpha(val:Float):Float
	{
		if (_wireAlpha == val)
			return val;
		
		_wireAlpha = val;
		
		#if flash9
		_graphicsStroke.fill.downcast(GraphicsSolidFill).alpha = _wireAlpha;
		
		#end
		return val;
	}
	
	/**

	 * Defines the thickness of the outline.
	 */
	private var _thickness:Float;
	public var thickness(get_thickness, set_thickness):Float;
	private inline function get_thickness():Float
	{
		return _thickness;
	}
	private function set_thickness(val:Float):Float
	{
		if (_thickness == val)
			return val;
		
		_thickness = val;
		
		#if flash9
		_graphicsStroke.thickness = _thickness;
		
		#end
		return val;
	}
	
	/**
	 * Creates a new <code>WireColorMaterial</code> object.
	 * 
	 * @param	color		The color of the material.
	 * @param	alpha		The transparency of the material.
	 * @param	wireColor	The color of the outline.
	 * @param	wireAlpha	The transparency of the outline.
	 * @param	thickness	The thickness of the outline.
	 */
	public function new(?color:Dynamic, ?alpha:Float = 1.0, ?wireColor:Dynamic, ?wireAlpha:Float = 1.0, ?thickness:Float = 1.0)
	{
		super(color, alpha);
		
		this._wireColor = (wireColor != null) ? Cast.color(wireColor) : 0x000000;
		this._wireAlpha = wireAlpha;
		
		this._thickness = thickness;
		
		#if flash9
		_graphicsStroke.fill = new GraphicsSolidFill(_wireColor, _wireAlpha);
		_graphicsStroke.thickness = _thickness;
		
		#end
	}
	
	#if !flash9
	override public function renderMesh(mesh:away3dlite.core.base.Mesh, camera:away3dlite.cameras.Camera3D, stage:jsflash.display.Stage):Void 
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
		gl.lineWidth(3);
		gl.drawElements(GLEnum.LINES, mesh.numItems, GLEnum.UNSIGNED_SHORT, 0);
		
	}
	
	#end
}