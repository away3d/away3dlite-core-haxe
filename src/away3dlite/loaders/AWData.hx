package away3dlite.loaders;

import away3dlite.containers.ObjectContainer3D;
import away3dlite.core.base.Mesh;
import away3dlite.core.base.Object3D;
import away3dlite.core.base.SortType;
import away3dlite.core.utils.Cast;
import away3dlite.materials.BitmapFileMaterial;
import away3dlite.haxeutils.FastStd;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;
import flash.Lib;
import flash.Vector;


//use namespace arcane;
using away3dlite.namespace.Arcane;
using away3dlite.haxeutils.HaxeUtils;

/**
* File loader/parser for the native .awd data file format.<br/>
*/

class AWData extends AbstractParser
{
	private var objs:Array<OData>;
	private var geos:Array<GData>;
	private var oList:Array<Dynamic>;
	private var aC:Array<ObjectContainer3D>;
	private var resolvedP:String;
	private var url:String;
	private var customPath:String;
	 
	/** @private */
	/*arcane*/ private override function prepareData(data:Dynamic):Void
	{
		var awdData:String = Cast.string(data);
		var lines:Array<String> = awdData.split('\n');
		if(lines.length == 1) lines = awdData.split(String.fromCharCode(13));
		//var trunk:Array<Dynamic>;
		var state:String = "";
		var isMesh:Bool = false;
		var isMaterial:Bool = false;
		var id:Int = 0;
		var buffer:Int=0;
		var oData:OData = null;
		var dline:Array<String> = null;
		var m:Matrix3D = null;
		var cont:ObjectContainer3D = null;
		var i:UInt;
		var version:String = "";
		
		for (line in lines)
		{
				if(line.substr(0,1) == "#" && state != line.substr(0,2)){
					state = line.substr(0,2);
					id = 0;
					buffer = 0;
					
					if(state == "#v")
						version = line.substr(3,line.length-4);
						
					if(state == "#f"){
						isMaterial = (FastStd.parseInt(line.substr(3,4)) == 2);
						resolvedP = "";
						if(isMaterial){
							if(customPath != ""){
								resolvedP = customPath;
							} else if(url != ""){
								var pathArray:Array<String> = url.split("/");
								pathArray.pop();
								resolvedP = (pathArray.length>0)?pathArray.join("/")+"/":pathArray.join("/");
							}
						}
					}
						
					if(state == "#t")
						isMesh = (line.substr(3,7) == "mesh");
					 
					continue;
				}
				
				dline = line.split(",");
				
				if(dline.length <= 1)
					continue;
					 
				if(state == "#o"){
					
					if(buffer == 0){
							id = FastStd.parseInt(dline[0]);
							//var temparr:Vector<Float> = Lib.vectorOfArray([FastStd.parseFloat(dline[1]),FastStd.parseFloat(dline[5]),FastStd.parseFloat(dline[9]),FastStd.parseFloat(dline[2]),FastStd.parseFloat(dline[6]),FastStd.parseFloat(dline[10]),FastStd.parseFloat(dline[3]),FastStd.parseFloat(dline[7]),FastStd.parseFloat(dline[11]),FastStd.parseFloat(dline[4]),FastStd.parseFloat(dline[8]),FastStd.parseFloat(dline[12]),0,0,0,1]);
							m = new Matrix3D(Lib.vectorOfArray([FastStd.parseFloat(dline[1]),FastStd.parseFloat(dline[2]),FastStd.parseFloat(dline[3]),FastStd.parseFloat(dline[4]),FastStd.parseFloat(dline[5]),FastStd.parseFloat(dline[6]),FastStd.parseFloat(dline[7]),FastStd.parseFloat(dline[8]),FastStd.parseFloat(dline[9]),FastStd.parseFloat(dline[10]),FastStd.parseFloat(dline[11]),FastStd.parseFloat(dline[12]),0,0,0,1]));
							++buffer;
					} else {
							var standardURL:Array<String> = null;
							if (customPath != "")
								standardURL = dline[12].split("/");
							
							m.position = new Vector3D(FastStd.parseFloat(dline[9]),FastStd.parseFloat(dline[10]),FastStd.parseFloat(dline[11]));
							oData = {name:(dline[0] == "")? "m_"+id: dline[0] ,
										transform:m,
										container:FastStd.parseInt(dline[4]),
										bothsides:(dline[5] == "true"),
										sortType: (dline[7] == "false" && dline[8] == "false") ? SortType.CENTER : ( (dline[7] == "true") ? SortType.FRONT : SortType.BACK),
										material: (isMaterial && dline[12] != null && dline[12] != "") ? ( resolvedP + ( (customPath != "") ?  standardURL[standardURL.length-1] : dline[12]) ) : null,
										geo: null};
										
							objs.push(oData);
							buffer = 0;
					}
					
				}
				
				if(state == "#d"){
					
					switch(buffer){
						case 0:
							id = geos.length;
							geos.push(cast {});
							++buffer;
							geos[id].aVstr = line.substring(2,line.length);
							
						case 1:
							geos[id].aUstr = line.substring(2,line.length);
							geos[id].aV= read(geos[id].aVstr).split(",");
							geos[id].aU= read(geos[id].aUstr).split(",");
							++buffer;
							
						case 2:
							geos[id].f= line.substr(2);
							buffer = 0;
							objs[id].geo = geos[id];
					}
					
				}
				
						
				if(state == "#c" && !isMesh){
					 
					id = FastStd.parseInt(dline[0]);
					cont = new ObjectContainer3D();
					//m = new Matrix3D(Lib.vectorOfArray([FastStd.parseFloat(dline[1]),FastStd.parseFloat(dline[5]),FastStd.parseFloat(dline[9]),FastStd.parseFloat(dline[2]),FastStd.parseFloat(dline[6]),FastStd.parseFloat(dline[10]),FastStd.parseFloat(dline[3]),FastStd.parseFloat(dline[7]),FastStd.parseFloat(dline[11]),FastStd.parseFloat(dline[4]),FastStd.parseFloat(dline[8]),FastStd.parseFloat(dline[12]),0.0,0.0,0.0,1.0]));
					m = new Matrix3D(Lib.vectorOfArray([FastStd.parseFloat(dline[1]),FastStd.parseFloat(dline[2]),FastStd.parseFloat(dline[3]),FastStd.parseFloat(dline[4]),FastStd.parseFloat(dline[5]),FastStd.parseFloat(dline[6]),FastStd.parseFloat(dline[7]),FastStd.parseFloat(dline[8]),FastStd.parseFloat(dline[9]),FastStd.parseFloat(dline[10]),FastStd.parseFloat(dline[11]),FastStd.parseFloat(dline[12]),0.0,0.0,0.0,1.0]));
					cont.transform.matrix3D = m;
					cont.name = (dline[13] == "null" || dline[13] == null)? "cont_"+id: dline[13];
					 
					aC.push(cont);
					 
					if(aC.length > 1)
						aC[0].addChild(cont);
				}
					
		}
		 
		var ref:OData;
		var mesh:Mesh = null;
		var j:Int;
		var av:Array<String>;
		var au:Array<String>;
		var aRef:Array<String>;
		var index:Int;
		 
		for(ref in objs){
			 
			index = 0;
			if(ref != null){
				mesh = new Mesh();
				mesh.type = "awd";
				mesh.bothsides = ref.bothsides;
				mesh.name = ref.name;
				mesh.transform.matrix3D = ref.transform;
				mesh.sortType = ref.sortType;
				 
				mesh.material = (ref.material == null) ? null : new BitmapFileMaterial(StringTools.urlDecode(ref.material));
				
				if(ref.container != -1 && !isMesh)
					aC[ref.container].addChild(mesh);

				aRef = ref.geo.f.split(",");

				j = 0;
				var len = aRef.length;
				while (j < len)
				{
					av = ref.geo.aV[FastStd.parseIntRadix(aRef[j], 16)].split("/");
					mesh.arcaneNS()._vertices.push3(FastStd.parseFloat(av[0]), -(FastStd.parseFloat(av[1])), FastStd.parseFloat(av[2]));
					av = ref.geo.aV[FastStd.parseIntRadix(aRef[j+1],16)].split("/");
					mesh.arcaneNS()._vertices.push3(FastStd.parseFloat(av[0]), -(FastStd.parseFloat(av[1])), FastStd.parseFloat(av[2]));
					av = ref.geo.aV[FastStd.parseIntRadix(aRef[j+2],16)].split("/");
					mesh.arcaneNS()._vertices.push3(FastStd.parseFloat(av[0]), -(FastStd.parseFloat(av[1])), FastStd.parseFloat(av[2]));

					mesh.arcaneNS()._indices.push3(index, index + 1, index + 2);
					mesh.arcaneNS()._faceLengths.push(3);
					index+=3;

					au = ref.geo.aU[FastStd.parseIntRadix(aRef[j+3],16)].split("/");
					mesh.arcaneNS()._uvtData.push3(FastStd.parseFloat(au[0]), 1-FastStd.parseFloat(au[1]), 0);
					au = ref.geo.aU[FastStd.parseIntRadix(aRef[j+4],16)].split("/");
					mesh.arcaneNS()._uvtData.push3(FastStd.parseFloat(au[0]), 1-FastStd.parseFloat(au[1]), 0);
					au = ref.geo.aU[FastStd.parseIntRadix(aRef[j+5],16)].split("/");
					mesh.arcaneNS()._uvtData.push3(FastStd.parseFloat(au[0]), 1 - FastStd.parseFloat(au[1]), 0);
					
					j += 6;
				}

				mesh.arcaneNS().buildFaces();
			}
		}
		
		_container = isMesh? mesh : aC[0];
		cleanUp(); 
	}
	
	private function cleanUp():Void
	{
		var i = -1;
		var len = objs.length;
		while (++i < len)
		{
			objs[i] == null;
		}
		objs = null;
		geos = null;
		oList = null;
		aC = null;
	}
	
	private function read(str:String):String
	{
		var start:Int= 0;
		var chunk:String;
		//var end:Int = 0;
		var dec:String = "";
		var charcount:Int = str.length;
		var i = -1;
		while (++i < charcount)
		{
			if (str.charCode(i)>=44 && str.charCode(i)<= 48 ){
				dec+= str.substring(i, i+1);
			}else{
				start = i;
				chunk = "";
				while(str.charCode(i)!=44 && str.charCode(i)!= 45 && str.charCode(i)!= 46 && str.charCode(i)!= 47 && i<=charcount){
					i++;
				}
				chunk = ""+FastStd.parseInt("0x"+str.substring(start, i));
				dec+= chunk;
				i--;
			}
		}
		return dec;
	}
	 
	/**
	 * Creates a new <code>AWData</code> object, a parser for .awd files.
	 * @see away3dlite.loaders.AWData#load()
	 * @see away3dlite.loaders.AWData#parse()
	 */
	public function new()
	{
		objs = [];
		geos = [];
		oList =[];
		aC = [];
		resolvedP = "";
		url = "";
		customPath = "";
		
		super();
	}

	/**
	* Parses and creates an Object3D from the raw ascii data of an .awd file. The Away3D native.awd data files.
	* Exporters to awd format are available in Away3d exporters package and in PreFab3D export options
	* 
	* @param	data				The ascii data of a .awd file.
	* @param	data				[optional] If the url for the source materials muts be changed.
	* Standard urls set for image sources from Prefab3D awd exports is "images/filename.jpg"
	* Example:
	* [Embed(source="aircraft/Aircraft.awd", mimeType="application/octet-stream")] 
	* private var Aircraft:Class;
	* [...] awaylite code
	* var myoutput:Object3D = AWData.parse(new Aircraft(), "mydisc/myfiles/");//path becomes then "mydisc/myfiles/filename.jpg"
	* scene.addChild(myoutput);
	* 
	* @return						An Object3D representation of the .awd file.
	*/
	public static function parse(data:Dynamic, ?sourcesUrl:String = ""):Object3D
	{	
		data = Cast.string(data);
		var parser:AWData = new AWData();
		
		if(sourcesUrl != "")
			parser.pathToSources = sourcesUrl;
			
		parser.prepareData(data);
		
		return parser._container;
	}
	 
	/**
	* Allows to set custom path to source(s) map(s) other than set in file
	* Standard output url from Prefab awd files is "images/filename.jpg"
	* when set pathToSources, url becomes  [newurl]filename.jpg.
	* Example: AWData.pathToSources = "mydisc/myfiles/";
	* Only required for load method using Loader3D
	* var awd:AWData = new AWData();
	* awd.pathToSources = "mydisc/myfiles/";
	* loader = new Loader3D();
	* loader.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
	* loader.loadGeometry("mymodels/car.awd", awd);
	*
	*/
	public var pathToSources(null, set_pathToSources):String;
	private function set_pathToSources(url:String):String
	{
		return customPath = url;
	}
}

typedef OData = {name:String,
				transform:Matrix3D,
				container:Int,
				bothsides:Bool,
				sortType:String,
				material:String,
				geo:GData };

typedef GData = { aVstr:String, aV:Array<String>, aUstr:String, aU:Array<String>, f:String };