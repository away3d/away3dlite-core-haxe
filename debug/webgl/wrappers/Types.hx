/**
 * ...
 * @author waneck
 */

package webgl.wrappers;
import js.Dom;
import html5.HTMLCanvasElement;

typedef GLenum = Int;
typedef GLboolean = Bool;
typedef GLbitfield = Int;
typedef GLbyte = Int;
typedef GLshort = Int;
typedef GLint = Int;
typedef GLsizei = Int;
typedef GLsizeiptr = Int;
typedef GLubyte = Int;
typedef GLushort = Int;
typedef GLuint = Int;
typedef GLfloat = Float;
typedef GLclampf = Float;

typedef WebGLContextAttributes =
{
	/**
	 * alpha
	 * Default: true. If the value is true, the drawing buffer has an alpha channel for the purposes
	 * of performing OpenGL destination alpha operations and compositing with the page. If the value
	 * is false, no alpha buffer is available. 
	 */
	/*?*/alpha:Bool,
	
	/**
	 * depth
	 * Default: true. If the value is true, the drawing buffer has a depth buffer of at least 16 bits.
	 * If the value is false, no depth buffer is available. 
	 */
	/*?*/depth:Bool,
	
	/**
	 * stencil
	 * Default: true. If the value is true, the drawing buffer has a stencil buffer of at least 8 bits.
	 * If the value is false, no stencil buffer is available. 
	 */
	/*?*/stencil:Bool,
	
	/**
	 * antialias
	 * Default: true. If the value is true and the implementation supports antialiasing the drawing buffer
	 * will perform antialiasing using its choice of technique (multisample/supersample) and quality.
	 * If the value is false or the implementation does not support antialiasing, no antialiasing is performed. 
	 */
	/*?*/antialias:Bool,
	
	/**
	 * premultipliedAlpha
	 * Default: true. If the value is true the page compositor will assume the drawing buffer contains colors
	 * with premultiplied alpha. If the value is false the page compositor will assume that colors in the drawing
	 * buffer are not premultiplied. This flag is ignored if the alpha flag is false. 
	 */
	/*?*/premultipliedAlpha:Bool
}


/**
 * The WebGLUniformLocation interface represents the location of a uniform variable in a shader program.
 */
extern class WebGLUniformLocation {  }


/**
 * return type of getActiveUniform
 */
extern class WebGLActiveInfo { 
	/**
	 * if the uniform variable being queried is an array, this variable 
	 * will be written with the maximum array element used in the 
	 * program (plus 1)
	 */
	var size(default, null):GLint;
	
	/**
	 * will be written with the uniform type, can be: 
	 * GL_FLOAT,GL_FLOAT_VEC2, GL_FLOAT_VEC3, GL_FLOAT_VEC4, 
	 * GL_INT, GL_INT_VEC2,GL_INT_VEC3, GL_INT_VEC4, GL_BOOL, 
	 * GL_BOOL_VEC2, GL_BOOL_VEC3, GL_BOOL_VEC4, 
	 * GL_FLOAT_MAT2, GL_FLOAT_MAT3,GL_FLOAT_MAT4, 
	 * GL_SAMPLER_2D, GL_SAMPLER_CUBE 
	 */
	var type(default, null):GLenum;
	
	/**
	 * will be written with the name of the uniform
	 */
	var name(default, null):String;
}

typedef WebGLResourceLostEvent = 
{ >Event,

	var resource(default, null):WebGLObject;
	var context(default, null):WebGLRenderingContext;
	
	function initWebGLResourceLostEvent(type:DOMString, canBubble:Bool, cancelable:Bool, resource:WebGLObject, context:WebGLRenderingContext):Void;
}