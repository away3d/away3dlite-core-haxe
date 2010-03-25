/**
 * ...
 * @author waneck
 */

package webgl;
import webgl.wrappers.Types;

extern class WebGLArray<TypeName> implements ArrayAccess<TypeName>
{
	//Since WebGLArray derivations can be instantiated, we have to enforce a package rename:
	static inline function __init__():Void untyped
	{
		__js__("if(typeof webgl=='undefined') webgl = {}
		try
	  	{
		    WebGLFloatArray;
		  }
		  catch (e)
		  {
		    try
		    {
		      WebGLFloatArray = CanvasFloatArray;
			  WebGLShortArray = CanvasShortArray;
		      WebGLUnsignedShortArray = CanvasUnsignedShortArray;
			  WebGLByteArray = CanvasByteArray;
			  WebGLUnsignedByteArray = CanvasUnsignedByteArray;
			  WebGLIntArray = CanvasIntArray;
			  WebGLUnsignedIntArray = CanvasUnsignedIntArray;
			  WebGLArrayBuffer = CanvasArrayBuffer;
		    }
		    catch (e)
		    {
		      alert(\"Could not find any WebGL array types.\");
		    }
		 }");
	}
	
	/**
	 * The WebGLArrayBuffer holding the data for this array. 
	 */
	public var buffer(default, null):WebGLArrayBuffer;
	
	/**
	 * The offset of this data, in bytes, from the start of this WebGLArray's WebGLArrayBuffer. 
	 */
	public var byteOffset(default, null):Int;
	
	/**
	 * The length of this data in bytes. 
	 */
	public var byteLength(default, null):Int;
	
	/**
	 * The length of this data in elements. 
	 */
	public var length(default, null):Int;
	
	/**
	 * Return the element at the given index. If the index is out of range, an exception is raised.
	 * This is an index getter function, and may be invoked via array index syntax where applicable. 
	 */
	public function get(index:Int):TypeName;
	
	/**
	 * Sets the element at the given index to the given value. If the index is out of range, an exception is raised.
	 * This is an index setter function, and may be invoked via array index syntax where applicable. 
	 * 
	 * If the given value is out of range for the type of the array, a C-style cast operation is
	 * performed to coerce the value to the valid range. No clamping or rounding is performed. 
	 */
	public function set(index:Int, value:TypeName):Void;
	
	//overloaded method.
	public inline function set2(array:WebGLArray<TypeName>, ?offset:Int):Void
	{
		untyped this.set(cast array, cast offset);
	}
	
	//overloaded method.
	public inline function set3(array:Array<TypeName>, ?offset:Int):Void
	{
		untyped this.set(cast array, cast offset);
	}
	
	/**
	 * Returns a new WebGLArray view of the WebGLArrayBuffer  store for this WebGLArray, referencing the element
	 * at offset in the current view, and containing length elements. 
	 * @param	offset
	 * @param	length
	 * @return	a new WebGLArray view of the WebGLArrayBuffer
	 */
	public function slice(offset:Int, length:Int):WebGLArray<TypeName>;

	/**
	 * Constructor(length)
	 * 
	 * Create a new WebGLTypeNameArray object of the given length with a new underlying WebGLArrayBuffer large enough
	 * to hold length  elements of the specific type. Data in the buffer is initialized to 0. 
	 * 
	 * 
	 * Constructor(array)
	 * 
	 * Create a new WebGLTypeNameArray object with a new underlying WebGLArrayBuffer large enough to hold the given data,
	 * then copy the passed data into the buffer. 
	 * 
	 * 
	 * Constructor(buffer, byteOffset, length)
	 * 
	 * Create a new WebGLTypeNameArray object using the passed WebGLArrayBuffer for its storage. Optional byteOffset and
	 * length can be used to limit the section of the buffer referenced. The byteOffset indicates the offset in bytes from
	 * the start of the WebGLArrayBuffer, and the length is the count of elements from the offset that this WebGLByteArray
	 * will reference. If both byteOffset and length are omitted, the WebGLTypeNameArray spans the entire WebGLArrayBuffer
	 * range. If the length is omitted, the WebGLTypeNameArray extends from the given byteOffset until the end of the
	 * WebGLArrayBuffer. 
	 * 
	 * @abstract class. private constructor.
	 * @param	params
	 */
	
	public function new(array:Array<TypeName>):Void;
	
	//overloaded constructor.
	public static inline function ctor1<T>(clazz:Class<T>, length:Int):T untyped
	{
		return __new__(clazz, length);
	}
	
	//overloaded constructor.
	public static inline function ctor2<T, K>(clazz:Class<T>, array:Array<K>):T untyped
	{
		return __new__(clazz, array);
	}
	
	//overloaded constructor.
	public static inline function ctor3<T>(clazz:Class<T>, buffer:WebGLArrayBuffer, ?byteOffset:Int, ?length:Int):T untyped
	{
		return __new__(clazz, array, byteOffset, length);
	}
}


extern class WebGLByteArray extends WebGLArray<GLbyte>
{
	static inline function __init__():Void untyped
	{
		__js__("webgl.WebGLByteArray = WebGLByteArray");
	}
	
	public static inline var BYTES_PER_ELEMENT:GLsizei = 1;
	
	public function new(param:Dynamic, ?byteOffset:Int, ?length:Int):Void;
}

extern class WebGLUnsignedByteArray extends WebGLArray<GLubyte>
{
	static inline function __init__():Void untyped
	{
		__js__("webgl.WebGLUnsignedByteArray = WebGLUnsignedByteArray");
	}
	
	public static inline var BYTES_PER_ELEMENT:GLsizei = 1;
	
	public function new(param:Dynamic, ?byteOffset:Int, ?length:Int):Void;
}

extern class WebGLShortArray extends WebGLArray<GLshort>
{
	static inline function __init__():Void untyped
	{
		__js__("webgl.WebGLShortArray = WebGLShortArray");
	}
	
	public static inline var BYTES_PER_ELEMENT:GLsizei = 2;
	
	public function new(param:Dynamic, ?byteOffset:Int, ?length:Int):Void;
}

extern class WebGLUnsignedShortArray extends WebGLArray<GLushort>
{
	static inline function __init__():Void untyped
	{
		__js__("webgl.WebGLUnsignedShortArray = WebGLUnsignedShortArray");
	}
	
	public static inline var BYTES_PER_ELEMENT:GLsizei = 2;
	
	public function new(param:Dynamic, ?byteOffset:Int, ?length:Int):Void;
}

extern class WebGLIntArray extends WebGLArray<GLint>
{
	static inline function __init__():Void untyped
	{
		__js__("webgl.WebGLIntArray = WebGLIntArray");
	}
	
	public static inline var BYTES_PER_ELEMENT:GLsizei = 4;
	
	public function new(param:Dynamic, ?byteOffset:Int, ?length:Int):Void;
}

extern class WebGLUnsignedIntArray extends WebGLArray<GLuint>
{
	static inline function __init__():Void untyped
	{
		__js__("webgl.WebGLUnsignedIntArray = WebGLUnsignedIntArray");
	}
	
	public static inline var BYTES_PER_ELEMENT:GLsizei = 4;
	
	public function new(param:Dynamic, ?byteOffset:Int, ?length:Int):Void;
}


extern class WebGLFloatArray extends WebGLArray<GLfloat>
{
	static inline function __init__():Void untyped
	{
		__js__("webgl.WebGLFloatArray = WebGLFloatArray");
	}
	
	public static inline var BYTES_PER_ELEMENT:GLsizei = 4;
	
	public function new(param:Dynamic, ?byteOffset:Int, ?length:Int):Void;
}


/**
 * The WebGLArrayBuffer interface describes the buffer used to store data for the WebGLArray interface and its subclasses. 
 */
extern class WebGLArrayBuffer
{
	static inline function __init__():Void untyped
	{
		__js__("webgl.WebGLArrayBuffer = WebGLArrayBuffer");
	}
	
	public function new(length:Int):Void;
	public var byteLength(default, null):Int;
}