//
//  Skeleton for a cross-target OpenGL implementation.
//
//  Created by Caue W. on 2010-03-23.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//
package opengl;

class OpenGL 
{
	#if js
	private static inline var WEBGL_CONTEXT = "experimental-webgl";
	
	private static var ctx:webgl.wrappers.WebGLRenderingContext;
	#end
	
	public static function init(?width:Int, ?height:Int #if js , ?canvas:html5.HTMLCanvasElement #end):Void 
	{
		#if js
		var ret:WebGLRenderingContext =	untyped canvas.getContext(WEBGL_CONTEXT, parameters);

		untyped __js__("webgl.wrappers.GLEnum = ret");
		return ret;
		
		#end
	}
	
	
	
	
}