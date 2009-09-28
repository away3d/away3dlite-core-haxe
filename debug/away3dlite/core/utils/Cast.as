package away3dlite.core.utils {
	
    import away3dlite.materials.*;
    
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;


    /**
     * Helper class for casting assets to usable objects
     */
    public class Cast
    {
		private static var hexchars:String = "0123456789abcdefABCDEF";
        private static var notclasses:Dictionary = new Dictionary();
        private static var classes:Dictionary = new Dictionary();
		
        private static function tryclass(name:String):Object
        {
            if (notclasses[name])
                return name;

            var result:Class = classes[name];

            if (result != null)
                return result;

            try
            {
                result = getDefinitionByName(name) as Class;
                classes[name] = result;
                return result;
            }
            catch (error:ReferenceError) {}

            notclasses[name] = true;
            return name;
        }
		
        private static function hexstring(string:String):Boolean
        {
            var _length:int = string.length;
            for (var i:int = 0; i < _length; ++i)
                if (hexchars.indexOf(string.charAt(i)) == -1)
                    return false;

            return true;
        }
        
    	/**
    	 * Casts the given data value as a string.
    	 */
        public static function string(data:*):String
        {
            if (data is Class)
                data = new data;

            if (data is String)
                return data;

            return String(data);
        }
        
    	/**
    	 * Casts the given data value as a bytearray.
    	 */
        public static function bytearray(data:*):ByteArray
        {
            //throw new Error(typeof(data));

            if (data is Class)
                data = new data;

            if (data is ByteArray)
                return data;

            return ByteArray(data);
        }
        
    	/**
    	 * Casts the given data value as an xml object.
    	 */
        public static function xml(data:*):XML
        {
            if (data is Class)
                data = new data;

            if (data is XML)
                return data;

            return XML(data);
        }
        
    	/**
    	 * Casts the given data value as a color.
    	 */
        public static function color(data:*):uint
        {
            if (data is uint)
                return data as uint;

            if (data is int)
                return data as uint;

            if (data is String)
            {
                if (data == "random")
                    return uint(Math.random()*0x1000000);
            
                if (((data as String).length == 6) && hexstring(data))
                    return parseInt("0x"+data);
            }

            return 0xFFFFFF;                                  
        }
        
    	/**
    	 * Casts the given data value as a bitmapdata object.
    	 */
        public static function bitmap(data:*):BitmapData
        {
            if (data == null)
                return null;

            if (data is String)
                data = tryclass(data);

            if (data is Class)
            {
                try
                {
                    data = new data;
                }
                catch (bitmaperror:ArgumentError)
                {
                    data = new data(0,0);
                }
            }

            if (data is BitmapData)
                return data;
			
			if (data is Bitmap)
            	if ((data as Bitmap).hasOwnProperty("bitmapData")) // if (data is BitmapAsset)
                	return (data as Bitmap).bitmapData;

            if (data is DisplayObject)
            {
                var ds:DisplayObject = data as DisplayObject;
                var bmd:BitmapData = new BitmapData(ds.width, ds.height, true, 0x00FFFFFF);
                var mat:Matrix = ds.transform.matrix.clone();
                mat.tx = 0;
                mat.ty = 0;
                bmd.draw(ds, mat, ds.transform.colorTransform, ds.blendMode, bmd.rect, true);
                return bmd;
            }

            throw new Error("Can't cast to bitmap: "+data);
        }
        
    	/**
    	 * Casts the given data value as a material object.
    	 */
        public static function material(data:*):Material
        {
            if (data == null)
                return null;

            if (data is String)
                data = tryclass(data);

            if (data is Class)
            {
                try
                {
                    data = new data;
                }
                catch (materialerror:ArgumentError)
                {
                    data = new data(0,0);
                }
            }

            if (data is Material)
                return data;

            if (data is int) 
                return new ColorMaterial(data);

            //if (data is MovieClip) 
            //    return new MovieMaterial(data);

            if (data is String)
            {
                if (data == "")
                    return null;
            }

            try
            {
                var bmd:BitmapData = Cast.bitmap(data);
                return new BitmapMaterial(bmd);
            }
            catch (error:Error) {}

            throw new Error("Can't cast to material: "+data);
        }
    }
}
