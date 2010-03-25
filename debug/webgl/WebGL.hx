/**
 * ...
 * @author waneck
 */

package webgl;
import js.Dom;
import webgl.wrappers.Types;
import webgl.wrappers.WebGLRenderingContext;

class WebGL 
{
	private static inline var WEBGL_CONTEXT = "experimental-webgl";

	public static function init(canvas:HtmlDom, ?parameters:WebGLContextAttributes):WebGLRenderingContext
	{
		var ret:WebGLRenderingContext = null;
		try {
			if (parameters != null)
				ret = untyped canvas.getContext(WEBGL_CONTEXT, parameters);
			else
				ret = untyped canvas.getContext(WEBGL_CONTEXT);
		}
		catch(e:Dynamic)
		{
			
		}
		
		if (ret == null)
		{
			js.Lib.alert("No WebGL Context was found!");
			throw "No WebGL Context was found!";
		}
		untyped __js__("if (!webgl.wrappers) webgl.wrappers = {}");
		untyped __js__("webgl.wrappers.GLEnum = ret");
		return ret;
	}
}