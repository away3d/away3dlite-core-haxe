/**
 * Matrix3D class for flash. Thanks for http://umehara.net/blog/matrix3d/ umhr
 * for much of the code to replicate the Matrix3D inner workings.
 * @author waneck
 */

package jsflash.geom;
import jsflash.FastMath;
import jsflash.Lib;
import jsflash.geom.Orientation3D;
import jsflash.Vector;

class Matrix3D 
{

	public var rawData(default, set_rawData):jsflash.Vector<Float>;
	public var position(get_position, set_position):Vector3D;
	public var rotation(get_rotation, set_rotation):Vector3D;
	public var scale(get_scale, set_scale):Vector3D;
	public var determinant(get_determinant, never):Float;
	
	private var dirty:Bool;
	
	public inline var SXX(get_SXX, set_SXX):Float;
	private inline function get_SXX()
		return rawData[0]
	private inline function set_SXX(val)
	{
		dirty = true;
		return rawData[0] = val;
	}
	
	public inline var SXY(get_SXY, set_SXY):Float;
	private inline function get_SXY()
		return rawData[4]
	private inline function set_SXY(val)
	{
		dirty = true;
		return rawData[4] = val;
	}
		
	public inline var SXZ(get_SXZ, set_SXZ):Float;
	private inline function get_SXZ()
		return rawData[8]
	private inline function set_SXZ(val)
	{
		dirty = true;
		return rawData[8] = val;
	}
	
	public inline var TX(get_TX, set_TX):Float;
	private inline function get_TX()
		return rawData[12]
	private inline function set_TX(val)
		return rawData[12] = val
		
		
	public inline var SYX(get_SYX, set_SYX):Float;
	private inline function get_SYX()
		return rawData[1]
	private inline function set_SYX(val)
	{
		dirty = true;
		return rawData[1] = val;
	}
	
	public inline var SYY(get_SYY, set_SYY):Float;
	private inline function get_SYY()
		return rawData[5]
	private inline function set_SYY(val)
	{
		dirty = true;
		return rawData[5] = val;
	}
		
	public inline var SYZ(get_SYZ, set_SYZ):Float;
	private inline function get_SYZ()
		return rawData[9]
	private inline function set_SYZ(val)
	{
		dirty = true;
		return rawData[9] = val;
	}
	
	public inline var TY(get_TY, set_TY):Float;
	private inline function get_TY()
		return rawData[13]
	private inline function set_TY(val)
		return rawData[13] = val
		
		
	public inline var SZX(get_SZX, set_SZX):Float;
	private inline function get_SZX()
		return rawData[2]
	private inline function set_SZX(val)
	{
		dirty = true;
		return rawData[2] = val;
	}
	
	public inline var SZY(get_SZY, set_SZY):Float;
	private inline function get_SZY()
		return rawData[6]
	private inline function set_SZY(val)
	{
		dirty = true;
		return rawData[6] = val;
	}
		
	public inline var SZZ(get_SZZ, set_SZZ):Float;
	private inline function get_SZZ()
		return rawData[10]
	private inline function set_SZZ(val)
	{
		dirty = true;
		return rawData[10] = val;
	}
	
	public inline var TZ(get_TZ, set_TZ):Float;
	private inline function get_TZ()
		return rawData[14]
	private inline function set_TZ(val)
		return rawData[14] = val
		
		
	public inline var SWX(get_SWX, set_SWX):Float;
	private inline function get_SWX()
		return rawData[3]
	private inline function set_SWX(val)
	{
		dirty = true;
		return rawData[3] = val;
	}
	
	public inline var SWY(get_SWY, set_SWY):Float;
	private inline function get_SWY()
		return rawData[7]
	private inline function set_SWY(val)
	{
		dirty = true;
		return rawData[7] = val;
	}
		
	public inline var SWZ(get_SWZ, set_SWZ):Float;
	private inline function get_SWZ()
		return rawData[11]
	private inline function set_SWZ(val)
	{
		dirty = true;
		return rawData[11] = val;
	}
	
	public inline var TW(get_TW, set_TZ):Float;
	private inline function get_TW()
		return rawData[15]
	private inline function set_TW(val)
		return rawData[15] = val

	public function new( ?data:jsflash.Vector<Float> ):Void
	{
		if (data != null)
			Internal().rawData = data;
		else
			identity();
		
		position = new Vector3D(rawData[12], rawData[13], rawData[14], rawData[15]);
		position.Internal().OnChange = posVectorHandler;
		dirty = true;
	}
	
	public inline function Internal():InternalMatrix3D
	{
		return cast this;
	}
	
	public function transpose():Void
	{
		dirty = true;
		rawData = jsflash.Lib.vectorOfArray(
				  [ rawData[0], rawData[4], rawData[8], rawData[12],
					rawData[1], rawData[5], rawData[9], rawData[13],
					rawData[2], rawData[6], rawData[10], rawData[14],
					rawData[3], rawData[7], rawData[11], rawData[15] ] );
	}
	
	public function prependTranslation( x:Float, y:Float, z:Float ):Void
	{
		rawData[12] += rawData[0]*x+rawData[4]*y+rawData[8]*z;
		rawData[13] += rawData[1]*x+rawData[5]*y+rawData[9]*z;
		rawData[14] += rawData[2]*x+rawData[6]*y+rawData[10]*z;
		rawData[15] += rawData[3]*x+rawData[7]*y+rawData[11]*z;
	}
	
	public function deltaTransformVector( v:Vector3D ):Vector3D
	{
		dirty = true;
		return new Vector3D((rawData[0]*v.x+rawData[4]*v.y+rawData[8]*v.z),(rawData[1]*v.x+rawData[5]*v.y+rawData[9]*v.z),(rawData[2]*v.x+rawData[6]*v.y+rawData[10]*v.z),(rawData[3]*v.x+rawData[7]*v.y+rawData[11]*v.z));
	}
	
	public function pointAt( pos:Vector3D, ?at:Vector3D, ?up:Vector3D ):Void
	{
		//FIXME: make pointAt replicate as3 behavior
		var currpos = position;
		var zvec = new Vector3D(currpos.x - pos.x, currpos.y - pos.y, currpos.z - pos.z);
		
		var xvec = at.clone();
		zvec.crossProduct(zvec);
		xvec.normalize();
		var yvec = zvec.clone();
		yvec.crossProduct(xvec);
		
		/*var rotMatrix = Lib.vectorOfArray(
			[xvec.x, xvec.y, xvec.z, 0,
			 yvec.x, yvec.y, yvec.z, 0,
			 zvec.x, zvec.y, zvec.z, 0,
			 0		,	  0,	  0, 1]);*/
		var rotMatrix = new Matrix3D (Lib.vectorOfArray(
			[xvec.x, yvec.x, zvec.x, 0,
			 xvec.y, yvec.y, zvec.y, 0,
			 xvec.z, yvec.z, zvec.z, 0,
			 0		,	  0,	  0, 1]));
		
		this.append(rotMatrix);
	}
	
	public function transformVectors( vin:jsflash.Vector<Float>, vout:jsflash.Vector<Float> ):Void
	{
		var n = vin.length;
		var temp = new Vector<Float>();
		var i = -3;
		while ((i += 3) < n)
		{
			vout[i] = rawData[0]*vin[i]+rawData[4]*vin[i+1]+rawData[8]*vin[i+2]+rawData[12];
			vout[i+1] = rawData[1]*vin[i]+rawData[5]*vin[i+1]+rawData[9]*vin[i+2]+rawData[13];
			vout[i+2] = rawData[2]*vin[i]+rawData[6]*vin[i+1]+rawData[10]*vin[i+2]+rawData[14];
		}
	}
	
	public function prependRotation( ?degrees:Float, ?axis:Vector3D, ?pivotPoint:Vector3D ):Void
	{
		dirty = true;
		if(pivotPoint == null){
			pivotPoint = new Vector3D(0, 0, 0);
		}
		var tempAxis:Vector3D = axis.clone();
		tempAxis.normalize();
		//AXIS_ANGLE to QUATERNION
		var degreesPIper360 = degrees / 360 * Math.PI;
		var w = Math.cos(degreesPIper360);
		var x = Math.sin(degreesPIper360) * tempAxis.x;
		var y = Math.sin(degreesPIper360) * tempAxis.y;
		var z = Math.sin(degreesPIper360) * tempAxis.z;
		
		//rawData from QUATERNION
		var p = RawDataFromQuaternion(x, y, z, w);
		
		//Matrix * entity
		rawData = matrix44Calculat(p, rawData);
		appendTranslation(pivotPoint.x,pivotPoint.y,pivotPoint.z);
	}
	
	public function RawDataFromQuaternion(x:Float,y:Float,z:Float,w:Float):Vector<Float> {
		dirty = true;
		var p = new jsflash.Vector<Float>();
		
		p[0] = (w*w+x*x-y*y-z*z);
		p[1] = 2*(y*x+w*z);
		p[2] = 2*(z*x-w*y);
		p[3] = 0;
		p[4] = 2*(y*x-w*z);
		p[5] = (w*w-x*x+y*y-z*z);
		p[6] = 2*(w*x+z*y);
		p[7] = 0;
		p[8] = 2*(z*x+w*y);
		p[9] = 2*(z*y-w*x);
		p[10] = (w*w-x*x-y*y+z*z);
		p[11] = 0;
		p[12] = 0;
		p[13] = 0;
		p[14] = 0;
		p[15] = 1;
		return p;
	}
	
	private function matrix44Calculat(e:Vector<Float>,p:Vector<Float>):Vector<Float> {
		var pe:Vector<Float> = new Vector<Float>();
		
		pe[0] = p[0]*e[0]+p[4]*e[1]+p[8]*e[2]+p[12]*e[3];
		pe[1] = p[1]*e[0]+p[5]*e[1]+p[9]*e[2]+p[13]*e[3];
		pe[2] = p[2]*e[0]+p[6]*e[1]+p[10]*e[2]+p[14]*e[3];
		pe[3] = p[3]*e[0]+p[7]*e[1]+p[11]*e[2]+p[15]*e[3];
		
		pe[4] = p[0]*e[4]+p[4]*e[5]+p[8]*e[6]+p[12]*e[7];
		pe[5] = p[1]*e[4]+p[5]*e[5]+p[9]*e[6]+p[13]*e[7];
		pe[6] = p[2]*e[4]+p[6]*e[5]+p[10]*e[6]+p[14]*e[7];
		pe[7] = p[3]*e[4]+p[7]*e[5]+p[11]*e[6]+p[15]*e[7];
		
		pe[8] = p[0]*e[8]+p[4]*e[9]+p[8]*e[10]+p[12]*e[11];
		pe[9] = p[1]*e[8]+p[5]*e[9]+p[9]*e[10]+p[13]*e[11];
		pe[10] = p[2]*e[8]+p[6]*e[9]+p[10]*e[10]+p[14]*e[11];
		pe[11] = p[3]*e[8]+p[7]*e[9]+p[11]*e[10]+p[15]*e[11];
		
		pe[12] = p[0]*e[12]+p[4]*e[13]+p[8]*e[14]+p[12]*e[15];
		pe[13] = p[1]*e[12]+p[5]*e[13]+p[9]*e[14]+p[13]*e[15];
		pe[14] = p[2]*e[12]+p[6]*e[13]+p[10]*e[14]+p[14]*e[15];
		pe[15] = p[3]*e[12]+p[7]*e[13]+p[11]*e[14]+p[15]*e[15];
		
		return pe;
	}
	
	public function prepend( rhs:Matrix3D ):Void
	{
		dirty = true;
		rawData = matrix44Calculat(rhs.rawData, rawData);
	}
	
	public function transformVector( v:Vector3D ):Vector3D
	{
		var ret = new Vector3D();
		ret.x = rawData[0]*v.x+rawData[4]*v.y+rawData[8]*v.z+rawData[12];
		ret.y = rawData[1]*v.x+rawData[5]*v.y+rawData[9]*v.z+rawData[13];
		ret.z = rawData[2]*v.x+rawData[6]*v.y+rawData[10]*v.z+rawData[14];
		ret.w = rawData[3]*v.x+rawData[7]*v.y+rawData[11]*v.z+rawData[15];
		return ret;
	}
	
	public function appendScale( xScale:Float, yScale:Float, zScale:Float ):Void
	{
		dirty = true;
		rawData[0]*=xScale;
		rawData[1]*=yScale;
		rawData[2]*=zScale;
		rawData[4]*=xScale;
		rawData[5]*=yScale;
		rawData[6]*=zScale;
		rawData[8]*=xScale;
		rawData[9]*=yScale;
		rawData[10]*=zScale;
		rawData[12]*=xScale;
		rawData[13]*=yScale;
		rawData[14]*=zScale;
	}
	
	
	public function decompose( ?orientation:Orientation3D ):jsflash.Vector<Vector3D>
	{
		if (orientation == null)
			orientation = EULER_ANGLES;
		
		var e = this.rawData;
		var vec = Matrix3dToEulerAnglePrepend(e);
		
		return switch(orientation)
		{
			case EULER_ANGLES:
				vec;
			default:
				Matrix3dToQuaternion(e, vec[2], orientation);
		}
	}
	
	public function Matrix3dToQuaternion(entity:Vector<Float>, scale:Vector3D, orientationStyle:Orientation3D) : Vector<Vector3D>
	{
		var e = entity.concat(Lib.vectorOfArray([]));
		if(scale.x > 0)
		{
			e[0]/=scale.x;
			e[4]/=scale.x;
			e[8]/=scale.x;
		}
		if(scale.y > 0)
		{
			e[1]/=scale.y;
			e[5]/=scale.y;
			e[9]/=scale.y;
		}
		if(scale.z > 0)
		{
			e[2]/=scale.z;
			e[6]/=scale.z;
			e[10]/=scale.z;
		}
		
		var w = 0.0, x = 0.0, y = 0.0, z:Float = 0;
		
		var math = Math;
		var _ar = [e[0]+e[5]+e[10],e[0]-e[5]-e[10],e[5]-e[0]-e[10],e[10]-e[0]-e[5]];
		var idx = 0;
		var val = _ar[0];
		var biggestIndex = 0;
		for (f in _ar)
		{
			if (f > val)
			{
				val = f;
				biggestIndex = idx;
			}
			idx++;
		}
		
		//var biggestIndex = Std.int(Lambda.fold(_ar, function(field, higher) return ((field > higher) ? field : higher), _ar[0]));
		var biggestVal = math.sqrt(_ar[biggestIndex]+1)*0.5;
		var mult = 0.25/biggestVal;
		
		switch (biggestIndex)
		{
			case 0:
				w = biggestVal;
				x = (e[6]-e[9])*mult;
				y = (e[8]-e[2])*mult;
				z = (e[1]-e[4])*mult;
			case 1:
				x = biggestVal;
				w = (e[6]-e[9])*mult;
				y = (e[4]+e[1])*mult;
				z = (e[2]+e[8])*mult;
			case 2:
				y = biggestVal;
				w = (e[8]-e[2])*mult;
				x = (e[4]+e[1])*mult;
				z = (e[9]+e[6])*mult;
			case 3:
				z = biggestVal;
				w = (e[1]-e[4])*mult;
				x = (e[2]+e[8])*mult;
				y = (e[9]+e[6])*mult;
			default:
				throw "unexpected error";
		}
		
		switch (orientationStyle)
		{
			//FIXME: returning incorrect values.
			//FIXME: NaN on w > 2
			case AXIS_ANGLE:
			{
				var acosw = math.acos(w);
				var sin_acosw = math.sin(acosw);
				if (sin_acosw != 0) 
				{
					x = x / sin_acosw;
					y = y / sin_acosw;
					z = z / sin_acosw;
					w = 2 * acosw;
				} else {
					x = y = z = w = 0;
				}
			}
			default:
		}
		return Lib.vectorOfArray([new Vector3D(e[12], e[13], e[14]), new Vector3D(x, y, z, w), new Vector3D(FastMath.abs(scale.x), FastMath.abs(scale.y), FastMath.abs(scale.z), FastMath.abs(scale.w))]);
	}
	
	
	public function Matrix3dToEulerAnglePrepend(e:Vector<Float>):Vector<Vector3D> 
	{
		var math = Math;
		var _z = math.atan2(e[1], e[0]);
		
		var sz = math.sin(_z);
		var cz = math.cos(_z);
		
		var _y = if (math.abs(cz) > 0.7)
				 math.atan2(-e[2], e[0]/cz);
		else
				 math.atan2(-e[2], e[1]/sz);
		
		var sy = math.sin(_y);
		var cy = math.cos(_y);
		
		var _x = if (math.abs(cz) > 0.7)
				 math.atan2((sy*sz-e[9]*cy/e[10]),cz);
		else
				 math.atan2((e[8]*cy/e[10]-sy*cz)/sz,1);
		
		var sx = math.sin(_x);
		var cx = math.cos(_x);
		
		
		var scale_x = (sy != 0) ? -e[2]/sy : (e[0] / (cy*cz));
		var scale_y = (sx != 0 && cy != 0) ? e[6]/(sx*cy) : (e[5]/(sx*sy*sz+cx*cz));
		var scale_z = (cx != 0 && cy != 0) ? e[10]/(cx*cy) : 1;
		
		return Lib.vectorOfArray([new Vector3D(e[12], e[13], e[14]), new Vector3D(_x, _y, _z), new Vector3D(scale_x, scale_y, scale_z)]);
	}
	
	public function recompose( components:jsflash.Vector<Vector3D>, ?orientation:Orientation3D ):Bool
	{
		dirty = true;
		if (orientation == null)
			orientation = EULER_ANGLES;
		
		var scale = [];
		scale[0] = scale[1] = scale[2] = components[2].x;
		scale[4] = scale[5] = scale[6] = components[2].y;
		scale[8] = scale[9] = scale[10] = components[2].z;
		
		var v = Lib.vectorOfArray([]);
		var math = Math;
		
		switch (orientation)
		{
			case EULER_ANGLES:
			{
				var cx = math.cos(components[1].x);
				var cy = math.cos(components[1].y);
				var cz = math.cos(components[1].z);
				var sx = math.sin(components[1].x);
				var sy = math.sin(components[1].y);
				var sz = math.sin(components[1].z);
				
				v[0]=cy*cz*scale[0];
				v[1]=cy*sz*scale[1];
				v[2]=- sy*scale[2];
				v[3]=0;
				v[4] = (sx*sy*cz-cx*sz)*scale[4];
				v[5] = (sx*sy*sz+cx*cz)*scale[5];
				v[6]=sx*cy*scale[6];
				v[7]=0;
				v[8] = (cx*sy*cz+sx*sz)*scale[8];
				v[9] = (cx*sy*sz-sx*cz)*scale[9];
				v[10]=cx*cy*scale[10];
				v[11]=0;
				v[12]=components[0].x;
				v[13]=components[0].y;
				v[14]=components[0].z;
				v[15]=1;
			}
			default:
			{
				var x = components[1].x;
				var y = components[1].y;
				var z = components[1].z;
				var w = components[1].w;
				if (Type.enumEq(orientation, AXIS_ANGLE))
				{
					x *= math.sin(w/2);
					y *= math.sin(w/2);
					z *= math.sin(w/2);
					w = math.cos(w/2);
				}
				
				v[0] = (1-2*y*y-2*z*z)*scale[0];
				v[1] = (2*x*y+2*w*z)*scale[1];
				v[2] = (2*x*z-2*w*y)*scale[2];
				v[3]=0;
				v[4] = (2*x*y-2*w*z)*scale[4];
				v[5] = (1-2*x*x-2*z*z)*scale[5];
				v[6] = (2*y*z+2*w*x)*scale[6];
				v[7]=0;
				v[8] = (2*x*z+2*w*y)*scale[8];
				v[9] = (2*y*z-2*w*x)*scale[9];
				v[10] = (1-2*x*x-2*y*y)*scale[10];
				v[11]=0;
				v[12]=components[0].x;
				v[13]=components[0].y;
				v[14]=components[0].z;
				v[15]=1;
			}
		}
		
		if (components[2].x == 0)
			v[0] = 1e-15;
		if (components[2].y == 0)
			v[5] = 1e-15;
		if (components[2].z == 0)
			v[10] = 1e-15;
			
		this.rawData = v;
		
		return !(components[2].x == 0 || components[2].y == 0 || components[2].y == 0);
	}
	
	
	//public function interpolateTo( toMat:Matrix3D, percent:Float ):Void;
	public function invert():Bool
	{
		dirty = true;
		var e = rawData;
		var e0 = e[0];
		var e1 = e[1];
		var e2 = e[2];
		var e3 = e[3];
		var e4 = e[4];
		var e5 = e[5];
		var e6 = e[6];
		var e7 = e[7];
		var e8 = e[8];
		var e9 = e[9];
		var e10 = e[10];
		var e11 = e[11];
		var e12 = e[12];
		var e13 = e[13];
		var e14 = e[14];
		var e15 = e[15];
		
		var a = new Vector<Float>();
		//aはadjugateから
		a[0]=cofactor(e5,e9,e13,e6,e10,e14,e7,e11,e15);
		a[1]=- cofactor(e4,e8,e12,e6,e10,e14,e7,e11,e15);
		a[2]=cofactor(e4,e8,e12,e5,e9,e13,e7,e11,e15);
		a[3]=- cofactor(e4,e8,e12,e5,e9,e13,e6,e10,e14);

		a[4]=- cofactor(e1,e9,e13,e2,e10,e14,e3,e11,e15);
		a[5]=cofactor(e0,e8,e12,e2,e10,e14,e3,e11,e15);
		a[6]=- cofactor(e0,e8,e12,e1,e9,e13,e3,e11,e15);
		a[7]=cofactor(e0,e8,e12,e1,e9,e13,e2,e10,e14);

		a[8]=cofactor(e1,e5,e13,e2,e6,e14,e3,e7,e15);
		a[9]=- cofactor(e0,e4,e12,e2,e6,e14,e3,e7,e15);
		a[10]=cofactor(e0,e4,e12,e1,e5,e13,e3,e7,e15);
		a[11]=- cofactor(e0,e4,e12,e1,e5,e13,e2,e6,e14);

		a[12]=- cofactor(e1,e5,e9,e2,e6,e10,e3,e7,e11);
		a[13]=cofactor(e0,e4,e8,e2,e6,e10,e3,e7,e11);
		a[14]=- cofactor(e0,e4,e8,e1,e5,e9,e3,e7,e11);
		a[15]=cofactor(e0,e4,e8,e1,e5,e9,e2,e6,e10);

		var d =e[0]*a[0]+e[1]*a[1]+e[2]*a[2]+e[3]*a[3];
		//dはdeterminantから
		if (d!=0) {
			rawData = jsflash.Lib.vectorOfArray([
				a[0]/d,a[4]/d,a[8]/d,a[12]/d,
				a[1]/d,a[5]/d,a[9]/d,a[13]/d,
				a[2]/d,a[6]/d,a[10]/d,a[14]/d,
				a[3]/d,a[7]/d,a[11]/d,a[15]/d]);
			return true;
		}
		return false;
	}
	
	private inline function cofactor(c0:Float, c1:Float, c2:Float, c3:Float, c4:Float, c5:Float, c6:Float, c7:Float, c8:Float)
	{
		return c0*(c4*c8-c5*c7) + c1*(c5*c6-c3*c8) + c2*(c3*c7-c4*c6);
	}
	
	public function appendTranslation( x:Float, y:Float, z:Float ):Void
	{
		rawData[12] += x;
		rawData[13] += y;
		rawData[14] += z;
	}
	
	public function appendRotation( degrees:Float, axis:Vector3D, ?pivotPoint:Vector3D ):Void
	{
		dirty = true;
		if(pivotPoint == null){
			pivotPoint = new Vector3D(0, 0, 0);
		}
		var tempAxis = axis.clone();

		//AXIS_ANGLE to QUATERNION
		var degreesPIper360 = degrees / 360 * Math.PI;
		var w = Math.cos(degreesPIper360);
		var x = Math.sin(degreesPIper360) * tempAxis.x;
		var y = Math.sin(degreesPIper360) * tempAxis.y;
		var z = Math.sin(degreesPIper360) * tempAxis.z;
		
		//rawData from QUATERNION
		var p = RawDataFromQuaternion(x, y, z, w);
		
		//Matrix * entity
		rawData = matrix44Calculat(rawData, p);
		appendTranslation(pivotPoint.x,pivotPoint.y,pivotPoint.z);
	}
	
	public function append( lhs:Matrix3D ):Void
	{
		dirty = true;
		rawData = matrix44Calculat(rawData,lhs.rawData);
	}
	
	public function prependScale( xScale:Float, yScale:Float, zScale:Float ):Void
	{
		dirty = true;
		rawData[0]*=xScale;
		rawData[1]*=xScale;
		rawData[2]*=xScale;
		rawData[3]*=xScale;
		rawData[4]*=yScale;
		rawData[5]*=yScale;
		rawData[6]*=yScale;
		rawData[7]*=yScale;
		rawData[8]*=zScale;
		rawData[9]*=zScale;
		rawData[10]*=zScale;
		rawData[11]*=zScale;
	}
	
	public function clone():Matrix3D
	{
		return new Matrix3D(rawData.concat(jsflash.Lib.vectorOfArray([])));
	}
	
	public function identity():Void
	{
		dirty = true;
		rawData = jsflash.Lib.vectorOfArray([1.0, 0, 0, 0,  0, 1, 0, 0,  0, 0, 1, 0,  0, 0, 0, 1]);
	}

	//public static function interpolate( thisMat:Matrix3D, toMat:Matrix3D, percent:Float ):Matrix3D;
	
	
	private function set_rawData(val)
	{
		dirty = true;
		return rawData = val.concat(Lib.vectorOfArray([]));
	}
	
	private function get_position()
	{
		position.Internal().Change(rawData[12], rawData[13], rawData[14], rawData[15]);
		
		return position;
	}
	
	private function set_position(val)
	{
		this.position = val;
		position.Internal().OnChange = posVectorHandler;
		posVectorHandler();
		
		return val;
	}
	
	private function posVectorHandler()
	{
		rawData[12] = Internal().position.x;
		rawData[13] = Internal().position.y;
		rawData[14] = Internal().position.z;
		rawData[15] = Internal().position.w;
	}
	
	private inline function get_scale():Vector3D
	{
		checkDirty();
		return scale;
	}
	
	private function checkDirty():Void
	{
		if (dirty)
		{
			var dec = this.Matrix3dToEulerAnglePrepend(rawData);
			
			if (Internal().scale != null)
				this.Internal().scale.Internal().OnChange = null;
			if (Internal().rotation != null)
				this.Internal().rotation.Internal().OnChange = null;
			
			this.Internal().scale = dec[2];
			this.Internal().rotation = new Vector3D(dec[1].x * FastMath.toDEGREES, dec[1].y * FastMath.toDEGREES, dec[1].z * FastMath.toDEGREES);
			
			dec[2].Internal().OnChange = scaleRotationHandler;
			this.Internal().rotation.Internal().OnChange = scaleRotationHandler;
			
			dirty = false;
		}
	}
	
	private function scaleRotationHandler()
	{
		checkDirty();
		//recompose([Internal().position, Internal().rotation, Internal().scale], Orientation3D.EULER_ANGLES);

		var math = Math;
		var v = rawData;
		
		var rotation = this.Internal().rotation;

		var cx = math.cos(rotation.x * FastMath.toRADIANS);
		var cy = math.cos(rotation.y * FastMath.toRADIANS);
		var cz = math.cos(rotation.z * FastMath.toRADIANS);
		var sx = math.sin(rotation.x * FastMath.toRADIANS);
		var sy = math.sin(rotation.y * FastMath.toRADIANS);
		var sz = math.sin(rotation.z * FastMath.toRADIANS);
		
		var scale = this.Internal().scale;
		var sc_x = scale.x;
		var sc_y = scale.y;
		var sc_z = scale.z;
		
		v[0]=cy*cz*sc_x;
		v[1]=cy*sz*sc_x;
		v[2]=- sy*sc_x;
		v[4] = (sx*sy*cz-cx*sz)*sc_y;
		v[5] = (sx*sy*sz+cx*cz)*sc_y;
		v[6]=sx*cy*sc_y;
		v[8] = (cx*sy*cz+sx*sz)*sc_z;
		v[9] = (cx*sy*sz-sx*cz)*sc_z;
		v[10]=cx*cy*sc_z;
	}
	
	private inline function set_scale(val:Vector3D):Vector3D
	{
		val.Internal().OnChange = scaleRotationHandler;
		scaleRotationHandler();
		return this.scale = val;
	}
	
	private inline function get_rotation():Vector3D
	{
		checkDirty();
		return rotation;
	}
	
	private inline function set_rotation(val:Vector3D):Vector3D
	{
		val.Internal().OnChange = scaleRotationHandler;
		scaleRotationHandler();
		
		return this.rotation = val;
	}
	
	
	private function get_determinant()
	{
		var e = rawData;
		var e0 = e[0];
		var e1 = e[1];
		var e2 = e[2];
		var e3 = e[3];
		var e4 = e[4];
		var e5 = e[5];
		var e6 = e[6];
		var e7 = e[7];
		var e8 = e[8];
		var e9 = e[9];
		var e10 = e[10];
		var e11 = e[11];
		var e12 = e[12];
		var e13 = e[13];
		var e14 = e[14];
		var e15 = e[15];
		
		var d = e0*sarrus(e5,e9,e13,e6,e10,e14,e7,e11,e15);

		d -= e1*sarrus(e4,e8,e12,e6,e10,e14,e7,e11,e15);
		d += e2*sarrus(e4,e8,e12,e5,e9,e13,e7,e11,e15);
		d -= e3*sarrus(e4,e8,e12,e5,e9,e13,e6,e10,e14);
		d -= ((e4-e8)*e1+(e9-e5)*e0)*e11*e14;
		return -d;
	}
	
	private inline function sarrus(c0:Float, c1:Float, c2:Float, c3:Float, c4:Float, c5:Float, c6:Float, c7:Float, c8:Float)
	{
		return c0*c4*c8 + c3*c7*c2 + c6*c1*c5 - c6*c4*c2 - c3*c1*c8 - c0*c7*c5;
	}
}

private typedef InternalMatrix3D =
{
	var rawData:Vector<Float>;
	var position:Vector3D;
	var scale:Vector3D;
	var rotation:Vector3D;
	
	var dirty:Bool;
}