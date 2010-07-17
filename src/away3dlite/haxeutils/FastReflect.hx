package away3dlite.haxeutils;

#if haxe_205 extern #end class FastReflect 
{

	public inline static function hasField( o : Dynamic, field : String ) : Bool untyped 
	{
			return o.hasOwnProperty( field );
	}
	
}