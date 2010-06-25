/**
 * ...
 * @author waneck
 */

package webgl.wrappers;

/**
 * The WebGLObject interface is the parent interface for all GL objects. 
 */
extern class WebGLObject { }

/**
 * The WebGLBuffer interface represents an OpenGL Buffer Object. The underlying object is created as if by calling
 * glGenBuffers, bound as if by calling  glBindBuffer  and destroyed as if by calling  glDeleteBuffers. 
 */
extern class WebGLBuffer extends WebGLObject { }

/**
 * The WebGLFramebuffer interface represents an OpenGL Framebuffer Object. The underlying object is created as if
 * by calling  glGenFramebuffers  , bound as if by calling  glBindFramebuffer  and destroyed as if by calling
 * glDeleteFramebuffers. 
 */
extern class WebGLFramebuffer extends WebGLObject { }

/**
 * The WebGLProgram interface represents an OpenGL Program Object. The underlying object is created as if by calling
 * glCreateProgram  , used as if by calling  glUseProgram  and destroyed as if by calling  glDeleteProgram. 
 */
extern class WebGLProgram extends WebGLObject, implements Dynamic { }

/**
 * The WebGLRenderbuffer interface represents an OpenGL Renderbuffer Object. The underlying object is created as if by
 * calling  glGenRenderbuffers  , bound as if by calling  glBindRenderbuffer  and destroyed as if by calling
 * glDeleteRenderbuffers. 
 */
extern class WebGLRenderbuffer extends WebGLObject { }
/**
 * The WebGLShader interface represents an OpenGL Shader Object. The underlying object is created as if by calling
 * glCreateShader  , attached to a Program as if by calling  glAttachShader  and destroyed as if by calling  glDeleteShader. 
 */
extern class WebGLShader extends WebGLObject { }

/**
 * The WebGLTexture interface represents an OpenGL Texture Object. The underlying object is created as if by calling
 * glGenTextures  , bound as if by calling  glBindTexture  and destroyed as if by calling  glDeleteTextures. 
 */
extern class WebGLTexture extends WebGLObject { }

/**
 * The WebGLObjectArray interface represents an array of WebGLObject objects. 
 */
extern class WebGLObjectArray implements ArrayAccess<WebGLObject>
{
	public var length(default, null):Int;
	public function get(index:Int):WebGLObject;
}