//
//  OpenGLContext
//
//  Created by Caue W. on 2010-03-23.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//
package opengl;

class OpenGLContext 
{
	/**
	 * 
	 * @return	the WebGLContextAttributes describing the current drawing buffer. 
	 */
	public function getContextAttributes():WebGLContextAttributes;
	


	public function bindFramebuffer(target:GLenum, framebuffer:WebGLFramebuffer):Void;

	public function bindRenderbuffer(target:GLenum, renderbuffer:WebGLRenderbuffer):Void;

	
	
	/**
	 * The GL_BLEND_COLOR may be used to calculate the source and destination blending factors.
	 * The color components are clamped to the range [0,1] before being stored. See glBlendFunc
	 * for a complete description of the blending operations.
	 * Initially the GL_BLEND_COLOR is set to (0, 0, 0, 0).
	 * 
	 * @param	red
	 * @param	green
	 * @param	blue
	 * @param	alpha
	 */
	public function blendColor(red:GLclampf, green:GLclampf, blue:GLclampf, alpha:GLclampf):Void;

	/**
	 * specify the equation used for both the RGB blend equation and the Alpha blend equation
	 * 
	 * @param	mode	specifies how source and destination colors are combined.
	 * 					It must be GL_FUNC_ADD, GL_FUNC_SUBTRACT, or GL_FUNC_REVERSE_SUBTRACT.
	 */
	public function blendEquation(mode:GLenum):Void;
	
	/**
	 * set the RGB blend equation and the alpha blend equation separately
	 * 
	 * @param	modeRGB		specifies the RGB blend equation, how the red, green, and blue
	 * 						components of the source and destination colors are combined.
	 * 						It must be GL_FUNC_ADD, GL_FUNC_SUBTRACT, or GL_FUNC_REVERSE_SUBTRACT.
	 * @param	modeAlpha	specifies the alpha blend equation, how the alpha component of the source
	 * 						and destination colors are combined. It must be GL_FUNC_ADD, GL_FUNC_SUBTRACT,
	 * 						or GL_FUNC_REVERSE_SUBTRACT.
	 */
	public function blendEquationSeparate(modeRGB:GLenum, modeAlpha:GLenum):Void;
	
	/**
	 * specify pixel arithmetic
	 * @param	sfactor		Specifies how the red, green, blue, and alpha source blending factors are computed.
	 * 						The following symbolic constants are accepted: GL_ZERO, GL_ONE, GL_SRC_COLOR, GL_ONE_MINUS_SRC_COLOR
	 * 						GL_DST_COLOR, GL_ONE_MINUS_DST_COLOR, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA, GL_DST_ALPHA,
	 * 						GL_ONE_MINUS_DST_ALPHA, GL_CONSTANT_COLOR, GL_ONE_MINUS_CONSTANT_COLOR, GL_CONSTANT_ALPHA,
	 * 						GL_ONE_MINUS_CONSTANT_ALPHA, and GL_SRC_ALPHA_SATURATE. The initial value is GL_ONE.
	 * @param	dfactor		Specifies how the red, green, blue, and alpha destination blending factors are computed.
	 * 						The following symbolic constants are accepted: GL_ZERO, GL_ONE, GL_SRC_COLOR, GL_ONE_MINUS_SRC_COLOR,
	 * 						GL_DST_COLOR, GL_ONE_MINUS_DST_COLOR, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA, GL_DST_ALPHA,
	 * 						GL_ONE_MINUS_DST_ALPHA. GL_CONSTANT_COLOR, GL_ONE_MINUS_CONSTANT_COLOR, GL_CONSTANT_ALPHA,
	 * 						and GL_ONE_MINUS_CONSTANT_ALPHA. The initial value is GL_ZERO.
	 * 
	 * @see 	http://www.khronos.org/opengles/sdk/docs/man/glBlendFunc.xml
	 */
	public function blendFunc(sfactor:GLenum, dfactor:GLenum):Void;
	
	
	public function blendFuncSeparate(srcRGB:GLenum, dstRGB:GLenum, srcAlpha:GLenum, dstAlpha:GLenum):Void;
	
	public function checkFramebufferStatus(target:GLenum):GLenum;
	public function clear(mask:GLbitfield):Void;
	public function clearColor(red:GLclampf, green:GLclampf, blue:GLclampf, alpha:GLclampf):Void;
	public function clearDepth(depth:GLclampf):Void;
	public function clearStencil(s:GLint):Void;
	public function colorMask(red:GLboolean, green:GLboolean, blue:GLboolean, alpha:GLboolean):Void;

	public function copyTexImage2D(target:GLenum, level:GLint, internalformat:GLenum, 
						x:GLint, y:GLint, width:GLsizei, height:GLsizei, 
						border:GLint):Void;
	public function copyTexSubImage2D(target:GLenum, level:GLint, xoffset:GLint, yoffset:GLint, 
						   x:GLint, y:GLint, width:GLsizei, height:GLsizei):Void;

	public function createFramebuffer():WebGLFramebuffer;
	public function createRenderbuffer():WebGLRenderbuffer;
	
	///////////SHADERS////////////
	/**
	 * Create new Shader object
	 * @param	type	can be either GL_VERTEX_SHADER or GL_FRAGMENT_SHADER
	 * @return
	 */
	public function createShader(type:GLenum):WebGLShader;
	
	/**
	 * Deletes a shader object. If it's attached to a program, it will only
	 * be marked for deletion when deattached to a program.
	 * @param	shader	WebGLShader object
	 */
	public function deleteShader(shader:WebGLShader):Void;
	
	/**
	 * Sets shader source code.
	 * @param	shader	WebGLShader object
	 * @param	source	source code to bind.
	 */
	public function shaderSource(shader:WebGLShader, source:String):Void;
	
	/**
	 * Compiler the shader
	 * @param	shader	WebGLShader object
	 */
	public function compileShader(shader:WebGLShader):Void;
	
	/**
	 * Query for shader information.
	 * @param	shader	WebGLShader object
	 * @param	pname	the parameter to get information about, can be: 
	 * 					COMPILE_STATUS
	 * 					DELETE_STATUS 
	 * 					INFO_LOG_LENGTH
	 * 					SHADER_SOURCE_LENGTH 
	 * 					SHADER_TYPE 
	 * @return	pointer to integer storage location for the result of the query
	 */
	public inline function getShaderiv(shader:WebGLShader, pname:GLenum):Int
	{
		return getShaderParameter(shader, pname);
	}
	
	public function getShaderParameter(shader:WebGLShader, pname:GLenum):Dynamic;
	
	/**
	 * Retrieve the shader's info log (after checking the info log length)
	 * @param	shader	WebGLShader object
	 * @return	Info log
	 */
	public function getShaderInfoLog(shader:WebGLShader):String;
	
	
	///////////PROGRAM////////////
	
	/**
	 * Creates a new program object
	 * @return	a new WebGLProgram
	 */
	public function createProgram():WebGLProgram;
	
	/**
	 * Deletes the program object.
	 * @param	program		a WebGLProgram object
	 */
	public function deleteProgram(program:WebGLProgram):Void;
	
	/**
	 * Once you have a program object created, the next step is to attach shaders 
	 * to it. In OpenGL ES 2.0, each program object will need to have one vertex 
	 * shader and one fragment shader object attached to it.
	 * 
	 * The shader doesn't have to be compiled, not even have a source code to be attached.
	 * 
	 * @param	program		a WebGLProgram object
	 * @param	shader		the WebGLShader object to be attached.
	 */
	public function attachShader(program:WebGLProgram, shader:WebGLShader):Void;
	
	/**
	 * Detaches a shader object from the selected program.
	 * @param	program
	 * @param	shader
	 */
	public function detachShader(program:WebGLProgram, shader:WebGLShader):Void;
	
	/**
	 * Once the two shaders have been attached, we need to link them
	 * with this method. Generates the final executable program.
	 * @param	program		a WebGLProgram object
	 */
	public function linkProgram(program:WebGLProgram):Void;
	
	/**
	 * Query for program information
	 * @param	program		the WebGLProgram object
	 * @param	pname		the parameter to get information about, can be: 
	 * 						GL_ACTIVE_ATTRIBUTES 
	 * 						GL_ACTIVE_ATTRIBUTE_MAX_LENGTH 
	 * 						GL_ACTIVE_UNIFORMS 
	 * 						GL_ACTIVE_UNIFORM_MAX_LENGTH 
	 * 						GL_ATTACHED_SHADERS 
	 * 						GL_DELETE_STATUS 
	 * 						GL_INFO_LOG_LENGTH 
	 * 						GL_LINK_STATUS 
	 * 						GL_VALIDATE_STATUS 
	 * @return	Int parameter
	 */
	public inline function getProgramiv(program:WebGLProgram, pname:GLenum):Int
	{
		return getProgramParameter(program, pname);
	}
	public function getProgramParameter(program:WebGLProgram, pname:GLenum):Dynamic;
	
	/**
	 * Retrieve the program's info log
	 * @param	program
	 * @return
	 */
	public function getProgramInfoLog(program:WebGLProgram):String;
	
	/**
	 * Check if the program will execute. Will show errors that aren't available
	 * at link time, but at draw time. Must have its validity checked with
	 * getProgramiv with pname as GL_VALIDATE_STATUS .
	 * 
	 * Use for debugging purposes only, it's a slow operation.
	 * @param	program
	 */
	public function validateProgram(program:WebGLProgram):Void;
	
	/**
	 * install a program object as part of current rendering state
	 * @param	program		Specifies the handle of the program object
	 *						whose executables are to be used as part of current
	 *						rendering state.
	 */
	public function useProgram(program:WebGLProgram):Void;
	
	
	///////////UNIFORMS AND ATTRIBUTES////////////
	//Uniforms are variables that store read-only constant values
	//Which are passed to the shader. (parameters)
	//To query for the list of active uniforms in a program, you first call 
	//glGetProgramiv with the GL_ACTIVE_UNIFORMS parameter.
	//An active uniform is one that is used y the program. 
	//The largest uniform name can be queried with the GL_ACTIVE_UNIFORM_MAX_ 
	//LENGTH parameter.
	
	/**
	 * Once we know the number of active uniforms and the number of characters 
	 * we need to store the uniform names, we can find out details on each uni- 
	 * form using glGetActiveUniform. 
	 * 
	 * @param	program
	 * @param	index
	 * @return
	 */
	public function getActiveUniform(program:GLuint, index:GLuint):WebGLActiveInfo;
	/*
	 * C version:
	 * glGetActiveUniform(GLuint program, GLuint index, 
                          GLsizei bufSize, GLsizei* length, 
                          GLint* size, GLenum* type, 
                          char* name) 
	 */
						  
	
	/**
	 * Once we have the name of the uniform, we can find its location using
	 * getUniformLocation. The uniform location is an integer value used to identify
	 * the location of the uniform in the program.
	 * 
	 * @param	program
	 * @param	name
	 * @return
	 */
	public function getUniformLocation(program:WebGLProgram, name:String):WebGLUniformLocation;
	

	/**
	 * Once we have the uniform location along with its type and array size, 
	 * we can then load the uniform with values. There are a number of different 
	 * functions for loading uniforms, with different functions for each uniform 
	 * type. 
	 */
	public function uniform1f(location:WebGLUniformLocation, x:GLfloat):Void;
	public function uniform1fv(location:WebGLUniformLocation, v:Array<Float>):Void;
	public inline function uniform1fv_2(location:WebGLUniformLocation, v:WebGLFloatArray):Void
	{
		uniform1fv(location, cast v);
	}

	public function uniform1i(location:WebGLUniformLocation, x:GLint):Void;
	public function uniform1iv(location:WebGLUniformLocation, v:Array<Int>):Void;
	public inline function uniform1iv_2(location:WebGLUniformLocation, v:WebGLIntArray):Void
	{
		return uniform1iv(location, cast v);
	}

	public function uniform2f(location:WebGLUniformLocation, x:GLfloat, y:GLfloat):Void;
	public function uniform2fv(location:WebGLUniformLocation, v:Array<Float>):Void;
	public inline function uniform2fv_2(location:WebGLUniformLocation, v:WebGLFloatArray):Void
	{
		uniform2fv(location, cast v);
	}

	public function uniform2i(location:WebGLUniformLocation, x:GLint, y:GLint):Void;
	public function uniform2iv(location:WebGLUniformLocation, v:Array<Int>):Void;
	public inline function uniform2iv_2(location:WebGLUniformLocation, v:WebGLIntArray):Void
	{
		return uniform2iv(location, cast v);
	}

	public function uniform3f(location:WebGLUniformLocation, x:GLfloat, y:GLfloat, z:GLfloat):Void;
	public function uniform3fv(location:WebGLUniformLocation, v:Array<Float>):Void;
	public inline function uniform3fv_2(location:WebGLUniformLocation, v:WebGLFloatArray):Void
	{
		uniform3fv(location, cast v);
	}

	public function uniform3i(location:WebGLUniformLocation, x:GLint, y:GLint, z:GLint):Void;
	public function uniform3iv(location:WebGLUniformLocation, v:Array<Int>):Void;
	public inline function uniform3iv_2(location:WebGLUniformLocation, v:WebGLIntArray):Void
	{
		return uniform3iv(location, cast v);
	}
	
	public function uniform4f(location:WebGLUniformLocation, x:GLfloat, y:GLfloat, z:GLfloat, w:GLfloat):Void;
	public function uniform4fv(location:WebGLUniformLocation, v:Array<Float>):Void;
	public inline function uniform4fv_2(location:WebGLUniformLocation, v:WebGLFloatArray):Void
	{
		uniform4fv(location, cast v);
	}
	
	public function uniform4i(location:WebGLUniformLocation, x:GLint, y:GLint, z:GLint, w:GLint):Void;
	public function uniform4iv(location:WebGLUniformLocation, v:Array<Int>):Void;
	public inline function uniform4iv_2(location:WebGLUniformLocation, v:WebGLIntArray):Void
	{
		return uniform4iv(location, cast v);
	}

	/**
	 * 
	 * @param	location
	 * @param	transpose	MUST BE FALSE in OpenGL ES 2.0. This argument 
							was kept for function interface compatibility
	 * @param	value
	 */
	public function uniformMatrix2fv(location:WebGLUniformLocation, transpose:GLboolean, 
						value:Array<Float>):Void;
	public inline function uniformMatrix2fv_2(location:WebGLUniformLocation, transpose:GLboolean, 
						value:WebGLFloatArray):Void
	{
		return uniformMatrix2fv(location, transpose, cast value);
	}

	public function uniformMatrix3fv(location:WebGLUniformLocation, transpose:GLboolean, 
						value:Array<Float>):Void;
	public inline function uniformMatrix3fv_2(location:WebGLUniformLocation, transpose:GLboolean, 
						value:WebGLFloatArray):Void
	{
		return uniformMatrix3fv(location, transpose, cast value);
	}

	public function uniformMatrix4fv(location:WebGLUniformLocation, transpose:GLboolean, 
						value:Array<Float>):Void;
	public inline function uniformMatrix4fv_2(location:WebGLUniformLocation, transpose:GLboolean, 
						value:Dynamic):Void untyped
	{
		uniformMatrix4fv(location, transpose, untyped value);
	}

	public function getUniform(program:WebGLProgram, location:WebGLUniformLocation):Dynamic;

	/////////////PRE-COMPILED SHADERS/////////////
	//Check for ability to compile a shader with GL_SHADER_COMPILER
	//using glGetBooleanv.
	//Once you are finished compiling any shaders for your application, you can 
	//call glReleaseShaderCompiler. This function provides a hint to the 
	//implementation that you are done with the shader compiler and it can free 
	//its resources.
	
	public inline function releaseCompilerShader():Void
	{
		//not supported on webgl implementation
	}
	
	//// Determine binary formats available 
	//glGetIntegerv(GL_NUM_SHADER_BINARY_FORMATS, &numBinaryFormats); 
	//formats = malloc(sizeof(GLint) * numBinaryFormats); 
	//glGetIntegerv(GL_SHADER_BINARY_FORMATS, formats); 
	//// "formats" now holds the list of supported binary formats 

	
	/**
	 * Loads a binary shader
	 * @param	n				number of shader objects in the shaders array
	 * @param	shaders			an array of shader object handles
	 * @param	binaryFormat	the vendor-specific binary format token
	 * @param	binary			pointer to the binary data generated by the offline compiler
	 */
	public inline function shaderBinary(n:GLint, shaders:Array<GLuint>, binaryFormat:GLenum, binary:BytesData):Void
	{
		throw "Not Supported on WebGL";
	}
	
	
	//Specifying vertex attribute data
	//All OpenGL ES 2.0 implementations must support a minimum of eight 
	//vertex attributes
	//GLint maxVertexAttribs;   // n will be >= 8 
	//glGetIntegerv(GL_MAX_VERTEX_ATTRIBS, &maxVertexAttribs); 


	/**
	 * Constant vertex attribute
	 * 
	 * A constant vertex attribute is the same for all vertices of a primitive, and 
	 * therefore only one value needs to be specified for all the vertices of a 
	 * primitive. 
	 */
	public function vertexAttrib1f(indx:GLuint, x:GLfloat):Void;
	public function vertexAttrib1fv(indx:GLuint, values:Array<Float>):Void;
	public inline function vertexAttrib1fv_2(indx:GLuint, values:WebGLFloatArray):Void
	{
		vertexAttrib1fv(indx, cast values);
	}

	public function vertexAttrib2f(indx:GLuint, x:GLfloat, y:GLfloat):Void;
	public function vertexAttrib2fv(indx:GLuint, values:Array<Float>):Void;
	public inline function vertexAttrib2fv_2(indx:GLuint, values:WebGLFloatArray):Void
	{
		vertexAttrib2fv(indx, cast values);
	}

	public function vertexAttrib3f(indx:GLuint, x:GLfloat, y:GLfloat, z:GLfloat):Void;
	public function vertexAttrib3fv(indx:GLuint, values:Array<Float>):Void;
	public inline function vertexAttrib3fv_2(indx:GLuint, values:WebGLFloatArray):Void
	{
		vertexAttrib3fv(indx, cast values);
	}
	
	public function vertexAttrib4f(indx:GLuint, x:GLfloat, y:GLfloat, z:GLfloat, w:GLfloat):Void;
	public function vertexAttrib4fv(indx:GLuint, values:Array<Float>):Void;
	public inline function vertexAttrib4fv_2(indx:GLuint, values:WebGLFloatArray):Void
	{
		vertexAttrib4fv(indx, cast values);
	}
	
	/**
	 * Vertex Arrays
	 * 
	 * Vertex arrays specify attribute data per vertex and are buffers stored in the 
	 * application’s address space (what OpenGL ES calls the client space).
	 * @param	indx		specifies the generic vertex attribute index. This value is 0 to 
							max vertex attributes supported – 1 
	 * @param	size		number of components specified in the vertex array for the 
							vertex attribute referenced by index. Valid values are 1–4
	 * @param	type		data format. Valid values are: 
							GL_BYTE 
							GL_UNSIGNED_BYTE 
							GL_SHORT 
							GL_UNSIGNED_SHORT 
							GL_FLOAT 
							GL_FIXED 
							GL_HALF_FLOAT_OES* (not available on WebGL)
	 * @param	normalized	is used to indicate whether the non-floating data format 
							type should be normalized or not when converted to floating 
							point  
	 * @param	stride		the components of vertex attribute specified by size are stored 
							sequentially for each vertex. stride specifies the delta 
							between data for vertex index I and vertex (I + 1). If stride is 
							0, attribute data for all vertices are stored sequentially. If 
							stride is > 0, then we use the stride value as the pitch to get 
							vertex data for next index 
	 * @param	offset
	 */
	public function vertexAttribPointer(indx:GLuint, size:GLint, type:GLenum, 
							normalized:GLboolean, stride:GLsizei, offset:GLsizeiptr):Void;
							
	/**
	 * They are used to enable and disable a generic vertex attribute array. 
	 * If the vertex attribute array is disabled for a generic attribute index, the con- 
	 * stant vertex attribute data specified for that index will be used.
	 * @param	index	specifies the generic vertex attribute index. This value is 0 to 
						max vertex attributes supported – 1 
	 */
	public function enableVertexAttribArray(index:GLuint):Void;

	public function disableVertexAttribArray(index:GLuint):Void;
	
	//The following line of code describes how to get the number of 
	//active vertex attributes. 
	//glGetProgramiv(progam, GL_ACTIVE_ATTRIBUTES, &numActiveAttribs); 

	
	/**
	 * The list of active vertex attributes used by a program and their data types 
	 * can be queried using the glGetActiveAttrib command. 
	 * 
	 * @param	program
	 * @param	index	index must be a value between 0 and 
						GL_ACTIVE_ATTRIBUTES – 1
	 * @return
	 */
	public function getActiveAttrib(program:GLuint, index:GLuint):WebGLActiveInfo;
	
	//Now we describe how to map this generic attribute 
	//index to the appropriate attribute variable declared in the vertex shader. 

	//There are two approaches that OpenGL ES 2.0 enables to map a generic ver- 
	//tex attribute index to an attribute variable name in the vertex shader. These 
	//approaches can be categorized as follows: 
	// • OpenGL ES 2.0 will bind the generic vertex attribute index to the 
	//attribute name. 
	// • The application can bind the vertex attribute index to an attribute 
	//name. 

	/**
	 * The glBindAttribLocation command can be used to bind a generic vertex 
	 * attribute index to an attribute variable in a vertex shader. This binding takes 
	 * effect when the program is linked the next time. It does not change the 
	 * bindings used by the currently linked program.
	 * @param	program		program object
	 * @param	index		index to be bound
	 * @param	name		attribute name
	 */
	public function bindAttribLocation(program:WebGLProgram, index:GLuint, name:String):Void;
	
	//The other option is to let OpenGL ES 2.0 bind the attribute variable name 
	//to a generic vertex attribute index. This binding is performed when the pro- 
	//gram is linked
	
	/**
	 * This assignment is implementation specific and can vary from one OpenGL 
	 * ES 2.0 implementation to another. An application can query the assigned 
	 * binding by using the glGetAttribLocation command. 
	 * @param	program		program object
	 * @param	name		attribute name
	 * @return				attribute location. If -1 is returned, invalid attribute index.
	 */
	public function getAttribLocation(program:WebGLProgram, name:String):GLint;	
	
	
	/////////////VERTEX BUFFER OBJECTS/////////////
	
	//There are two types of buffer objects supported by OpenGL ES: array 
	//buffer objects and element array buffer objects. The array buffer objects speci- 
	//fied by the GL_ARRAY_BUFFER token are used to create buffer objects that 
	//will store vertex data. The element array buffer objects specified by the 
	//GL_ELEMENT_ARRAY_BUFFER token are used to create buffer objects that will 
	//store indices of a primitive. 
	////To get best performance, we recommend that OpenGL ES 2.0 
	////applications use vertex buffer objects for vertex attribute data and 
	////element indices wherever possible. 
	
	/**
	void   initVertexBufferObjects(vertex_t *vertexBuffer, 
								   GLushort *indices, 
								   GLuint numVertices, GLuint numIndices 
								   GLuint *vboIds) 
	{ 
		glGenBuffers(2, vboIds); 
		glBindBuffer(GL_ARRAY_BUFFER, vboIds[0]); 
		glBufferData(GL_ARRAY_BUFFER, numVertices * sizeof(vertex_t), 
					 vertexBuffer, GL_STATIC_DRAW); 
		// bind buffer object for element indices 
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vboIds[1]); 
		glBufferData(GL_ELEMENT_ARRAY_BUFFER, 
					 numIndices * sizeof(GLushort),indices, 
					 GL_STATIC_DRAW); 
	}
	**/

	
	/**
	 * creates a new buffer object
	 * @return	new WebGLBuffer object
	 */
	public function createBuffer():WebGLBuffer;
	
	/**
	 * 
	 * @param	n	number of buffer objects to return
	 * @return		array of buffer objects.
	 */
	public inline function genBuffers(n:GLsizei):Array<WebGLBuffer>
	{
		var retarr = [];
		while (n-- > 0)
			retarr.push(createBuffer());
		return retarr;
	}
	
	/**
	 * The glBindBuffer command is used to make a buffer object the current 
	 * array buffer object or the current element array buffer object. The first time 
	 * a buffer object name is bound by calling glBindBuffer, the buffer object is 
	 * allocated with appropriate default state, and if the allocation is successful, 
	 * this allocated object is bound as the current array buffer object or the cur- 
	 * rent element array buffer object for the rendering context. 
	 * @param	target		can be set to GL_ARRAY_BUFFER or GL_ELEMENT_ARRAY_BUFFER
	 * @param	buffer		buffer object to be assigned as the current object to target
	 */
	public function bindBuffer(target:GLenum, buffer:WebGLBuffer):Void;
	
	/**
	 * • GL_BUFFER_SIZE. This refers to the size of the buffer object data that is 
	 * specified by glBufferData. The initial value when the buffer object is 
	 * first bound using glBindBuffer is zero. 
	 * • GL_BUFFER_USAGE. This is a hint as to how the application is going to 
	 * use the data stored in the buffer object. The initial value is GL_STATIC_DRAW. 
	 */
	
	//Buffer Usage Enum 		Description 
	//GL_STATIC_DRAW 			The buffer object data will be specified once by the 
	//							application and used many times to draw primitives. 
	//GL_DYNAMIC_DRAW 			The buffer object data will be specified repeatedly by the 
	//							application and used many times to draw primitives. 
	//GL_STREAM_DRAW 			The buffer object data will be specified once by the 
	//							application and used a few times to draw primitives.
	
	/**
	 * The vertex array data or element array data storage is created and initialized 
	 * using the glBufferData command. 
	 * glBufferData will reserve appropriate data storage based on the value of 
	 * size.
	 * 
	 * If data is a valid pointer, then contents of 
	 * data are copied to the allocated data store. 
	 * 
	 * @param	target		can be set to GL_ARRAY_BUFFER or GL_ELEMENT_ARRAY_BUFFER
	 * @param	size		size of buffer data store in bytes 
	 * @param	data		the buffer data supplied by the application 
	 * @param	usage		a hint on how the application is going to use the data stored 
	 * 						in the buffer object.
	 */
	public function bufferData(target:GLenum, size:GLsizei, usage:GLenum):Void;
	//overloaded function.
	public inline function bufferData_2(target:GLenum, data:WebGLArray<Dynamic>, usage:GLenum):Void
	{
		untyped bufferData(target, cast data, usage);
	}

	//overloaded function.
	public inline function bufferData_3(target:GLenum, data:WebGLArrayBuffer, usage:GLenum):Void
	{
		untyped bufferData(target, cast data, usage);
	}
	
	
	/**
	 * The contents of the buffer object data store can be initialized or 
	 * updated using the glBufferSubData command. 
	 * @param	target		can be set to GL_ARRAY_BUFFER or GL_ELEMENT_ARRAY_BUFFER
	 * @param	offset		offset into the buffer data store and number of bytes of the 
	 * @param	data		pointer to the client data that needs to be copied into the 
							buffer object data storage
	 */
	public function bufferSubData(target:GLenum, offset:GLsizeiptr, data:WebGLArray<Dynamic>):Void;
	//overloaded function.
	public inline function bufferSubData_2(target:GLenum, offset:GLsizeiptr, data:WebGLArrayBuffer):Void
	{
		untyped bufferSubData(target, offset, cast data);
	}
	
	//After the buffer object data store has been initialized or updated using 
	//glBufferData or glBufferSubData, the client data store is no longer 
	//needed and can be released. For static geometry, applications can free the 
	//client data store and reduce the overall system memory consumed by the 
	//application. This might not be possible for dynamic geometry. 
	
	
	public function deleteBuffer(buffer:WebGLBuffer):Void;
	
	
	
	
	////////////DRAWING////////////
	
	/**
	 * Specifies the width of the line drawed with GL_LINES, GL_LINE_STRIP GL_LINE_LOOP
	 * @param	width	Defaults to 1.0
	 */
	public function lineWidth(width:GLfloat):Void;
	
	//point sprites
	
	//A point sprite is drawn for each vertex specified.
	//A point sprite is a screen-aligned quad specified as a position and a radius. The 
	//position describes the center of the square and the radius is then used to cal- 
	//culate the four coordinates of the quad that describes the point sprite. 

	
	/***
	gl_PointSize is the built-in variable that can be used to output the point 
	radius (or point size) in the vertex shader. It is important that a vertex 
	shader associated with the point primitive output gl_PointSize, otherwise 
	the value of point size is considered undefined and will most likely result in 
	drawing errors. The gl_PointSize value output by a vertex shader will be 
	clamped to the aliased point size range supported by the OpenGL ES 2.0 
	implementation. This range can be queried using the following command. 
	GLfloat   pointSizeRange[2]; 
	glGetFloatv(GL_ALIASED_POINT_SIZE_RANGE, pointSizeRange); 
	By default, OpenGL ES 2.0 describes the window origin (0, 0) to be the (left, 
	bottom) region. However, for point sprites, the point coordinate origin is 
	(left, top). 
	gl_PointCoord is a built-in variable available only inside a fragment shader 
	when the primitive being rendered is a point sprite. gl_PointCoord is 
	declared as a vec2 variable using the mediump precision qualifier. The values 
	assigned to gl_PointCoord go from 0.0 to 1.0 as we move from left to right 
	or from top to bottom
	***/ 
	
	
	
	
	
	///////////TEXTURING////////////
	
	
	public inline function genTextures(n:GLsizei):Array<WebGLTexture>
	{
		var ret = [];
		var a = n;
		while (a-- > 0)
			ret.push(createTexture());
		return ret;
	}
	
	public function createTexture():WebGLTexture;
	
	public function deleteTexture(texture:WebGLTexture):Void;
	
	
	/**
	 * Specifies which texture unit to make active. The number
	 * of texture units is implementation dependent, but must be at least
	 * two. texture must be one of GL_TEXTUREi, where
	 * i ranges from 0 to (GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS - 1). 
	 * The initial value is GL_TEXTURE0.
	 * 
	 * @param	texture
	 */
	public function activeTexture(texture:GLenum):Void;
	
	/**
	 * 
	 * @param	target		bind the texture object to target GL_TEXTURE_2D or 
							GL_TEXTURE_CUBE_MAP 
	 * @param	texture		texture object to be bound.
	 */
	public function bindTexture(target:GLenum, texture:WebGLTexture):Void;
	

	
	/**
	 * Once a texture is bound to a particular texture target, that texture object will 
	 * remain bound to that target until it is deleted. After generating a texture 
	 * object and binding it, the next step to using a texture is to actually load the 
	 * image data. The primary function that is used for loading textures is 
	 * glTexImage2D. 
	 * 
	 * In comparison with OpenGL, the following parameters were omitted:
	 * internalFormat :	RGB, RGBA, ALPHA..
	 * width
	 * height
	 * border :			compatibility parameter. Must be 0.
	 * 
	 * 
	 * @param	target					specifies the texture target, either GL_TEXTURE_2D 
										or one of the cubemap face targets (e.g., 
										GL_TEXTURE_CUBE_MAP_POSITIVE_X, 
										GL_TEXTURE_CUBE_MAP_NEGATIVE_X, etc.) 
	 * @param	level					specifies which mip level to load. The base level is specified by 
										0 followed by an increasing level for each successive mipmap 
	 * @param	pixels					
	 * @param	?flipY
	 * @param	?asPremultipliedAlpha
	 */
	public function texImage2D(target:GLenum, level:GLint, pixels:ImageData,
					?flipY:GLboolean, ?asPremultipliedAlpha:GLboolean):Void;
					
	
	//overloaded functions.
	public inline function texImage2D_2(target:GLenum, level:GLint, image:Image,
					?flipY:GLboolean, ?asPremultipliedAlpha:GLboolean):Void
	{
		texImage2D(target, level, cast image, flipY, asPremultipliedAlpha);
	}
	public inline function texImage2D_3(target:GLenum, level:GLint, image:HTMLCanvasElement,
					?flipY:GLboolean, ?asPremultipliedAlpha:GLboolean):Void
	{
		texImage2D(target, level, cast image, flipY, asPremultipliedAlpha);
	}
	public inline function texImage2D_4(target:GLenum, level:GLint, image:HTMLVideoElement,
					?flipY:GLboolean, ?asPremultipliedAlpha:GLboolean):Void
	{
		texImage2D(target, level, cast image, flipY, asPremultipliedAlpha);
	}
	

	public function cullFace(mode:GLenum):Void;


	public function deleteFramebuffer(framebuffer:WebGLFramebuffer):Void;
	
	public function deleteRenderbuffer(renderbuffer:WebGLRenderbuffer):Void;
	

	
	public function disable(cap:GLenum):Void;
	public function depthFunc(func:GLenum):Void;
	public function depthMask(flag:GLboolean):Void;
	public function depthRange(zNear:GLclampf, zFar:GLclampf):Void;

	public function drawArrays(mode:GLenum, first:GLint, count:GLsizei):Void;
	public function drawElements(mode:GLenum, count:GLsizei, type:GLenum, offset:GLsizeiptr):Void;

	public function enable(cap:GLenum):Void;

	public function finish():Void;
	public function flush():Void;
	public function framebufferRenderbuffer(target:GLenum, attachment:GLenum, 
								renderbuffertarget:GLenum, 
								renderbuffer:WebGLRenderbuffer):Void;
	public function framebufferTexture2D(target:GLenum, attachment:GLenum, textarget:GLenum, 
							texture:WebGLTexture, level:GLint):Void;
	public function frontFace(mode:GLenum):Void;

	public function generateMipmap(target:GLenum):Void;

	
	public function getAttachedShaders(program:GLuint):WebGLObjectArray;



	public function getParameter(pname:GLenum):Dynamic;
	public function getBufferParameter(target:GLenum, pname:GLenum):Dynamic;

	public function getError():GLenum;

	public function getFramebufferAttachmentParameter(target:GLenum, attachment:GLenum, 
										  pname:GLenum):Dynamic;
	
	public function getRenderbufferParameter(target:GLenum, pname:GLenum):Dynamic;

	public function getShaderSource(shader:WebGLShader):DOMString;
	public function getString(name:GLenum):DOMString;

	public function getTexParameter(target:GLenum, pname:GLenum):Dynamic;


	public function getVertexAttrib(index:GLuint, pname:GLenum):Dynamic;

	public function getVertexAttribOffset(index:GLuint, pname:GLenum):GLsizeiptr;

	public function hint(target:GLenum, mode:GLenum):Void;
	public function isBuffer(buffer:WebGLObject):GLboolean;
	public function isEnabled(cap:GLenum):GLboolean;
	public function isFramebuffer(framebuffer:WebGLObject):GLboolean;
	public function isProgram(program:WebGLObject):GLboolean;
	public function isRenderbuffer(renderbuffer:WebGLObject):GLboolean;
	public function isShader(shader:WebGLObject):GLboolean;
	public function isTexture(texture:WebGLObject):GLboolean;

	public function pixelStorei(pname:GLenum, param:GLint):Void;
	public function polygonOffset(factor:GLfloat, units:GLfloat):Void;

	public function readPixels(x:GLint, y:GLint, width:GLsizei, height:GLsizei, 
						   format:GLenum, type:GLenum):WebGLArray<Dynamic>;

	public function renderbufferStorage(target:GLenum, internalformat:GLenum,
							width:GLsizei, height:GLsizei):Void;
	public function sampleCoverage(value:GLclampf, invert:GLboolean):Void;
	public function scissor(x:GLint, y:GLint, width:GLsizei, height:GLsizei):Void;

	public function stencilFunc(func:GLenum, ref:GLint, mask:GLuint):Void;
	public function stencilFuncSeparate(face:GLenum, func:GLenum, ref:GLint, mask:GLuint):Void;
	public function stencilMask(mask:GLuint):Void;
	public function stencilMaskSeparate(face:GLenum, mask:GLuint):Void;
	public function stencilOp(fail:GLenum, zfail:GLenum, zpass:GLenum):Void;
	public function stencilOpSeparate(face:GLenum, fail:GLenum, zfail:GLenum, zpass:GLenum):Void;

	//overloaded function.
	public inline function texImage2D_5(target:GLenum, level:GLint, internalformat:GLenum, 
					width:GLsizei, height:GLsizei, border:GLint, format:GLenum, 
					type:GLenum, pixels:WebGLArray<Dynamic>):Void untyped
	{
		texImage2D.apply([target, level, internalformat, width, height, border, format, type, pixels]);
	}

	public function texParameterf(target:GLenum, pname:GLenum, param:GLfloat):Void;
	public function texParameteri(target:GLenum, pname:GLenum, param:GLint):Void;


	public function texSubImage2D(target:GLenum, level:GLint, xoffset:GLint, yoffset:GLint, 
					   pixels:ImageData,
					   ?flipY:GLboolean, ?asPremultipliedAlpha:GLboolean):Void;
	public inline function texSubImage2D_2(target:GLenum, level:GLint, xoffset:GLint, yoffset:GLint, 
					   image:Image,
					   ?flipY:GLboolean, ?asPremultipliedAlpha:GLboolean):Void untyped
	{
		this.texSubImage2D(target, level, xoffset, yoffset, untyped image, flipY, asPremultipliedAlpha);
	}
	public inline function texSubImage2D_3(target:GLenum, level:GLint, xoffset:GLint, yoffset:GLint, 
					   image:HTMLCanvasElement,
					   ?flipY:GLboolean, ?asPremultipliedAlpha:GLboolean):Void
	{
		this.texSubImage2D(target, level, xoffset, yoffset, untyped image, flipY, asPremultipliedAlpha);
	}
	public inline function texSubImage2D_4(target:GLenum, level:GLint, xoffset:GLint, yoffset:GLint, 
					   image:HTMLVideoElement ,
					   ?flipY:GLboolean, ?asPremultipliedAlpha:GLboolean):Void
	{
		this.texSubImage2D(target, level, xoffset, yoffset, untyped image, flipY, asPremultipliedAlpha);
	}
	public inline function texSubImage2D_5(target:GLenum, level:GLint, xoffset:GLint, yoffset:GLint, 	
					   width:GLsizei, height:GLsizei, 
					   format:GLenum, type:GLenum, pixels:WebGLArray<Int>):Void untyped
	{
		texSubImage2D.apply([target, level, xoffset, yoffset, width, height, format, type, pixels]);
	}

	public function viewport(x:GLint, y:GLint, width:GLsizei, height:GLsizei):Void;
	
}