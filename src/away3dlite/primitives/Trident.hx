package away3dlite.primitives;

import away3dlite.containers.ObjectContainer3D;
import away3dlite.materials.WireframeMaterial;
import flash.Vector;

import flash.geom.Vector3D;

/**
 * Creates an axis trident.
 */
class Trident extends ObjectContainer3D
{
	private var _lines:Vector<LineSegment>;
	private var _cones:Vector<Cone>;

	/**
	 * Creates a new <code>Trident</code> object.
	 *
	 * @param	 radius				The radius of the trident axes. Default is 500.
	 */
	public function new(?radius:Int = 500, ?hasNegativeTrident:Bool = false)
	{
		// lines
		_lines = new Vector<LineSegment>();
		_lines.push(new LineSegment(new WireframeMaterial(0xFF0000), new Vector3D(), new Vector3D(radius, 0, 0)));
		_lines.push(new LineSegment(new WireframeMaterial(0x00FF00), new Vector3D(), new Vector3D(0, radius, 0)));
		_lines.push(new LineSegment(new WireframeMaterial(0x0000FF), new Vector3D(), new Vector3D(0, 0, radius)));
		if (hasNegativeTrident)
		{
			_lines.push(new LineSegment(new WireframeMaterial(0x660000), new Vector3D(), new Vector3D(-radius, 0, 0)));
			_lines.push(new LineSegment(new WireframeMaterial(0x006600), new Vector3D(), new Vector3D(0, -radius, 0)));
			_lines.push(new LineSegment(new WireframeMaterial(0x000066), new Vector3D(), new Vector3D(0, 0, -radius)));
		}

		for (i in 0..._lines.length)
		{
			var _line = _lines[i];
			addChild(_line);
		}

		// cones
		_cones = new Vector<Cone>();

		var xCone:Cone = new Cone(new WireframeMaterial(0xFF0000), 10, 20, 4);
		xCone.x = radius;
		xCone.rotationZ = 90;
		_cones.push(addChild(xCone));

		var yCone:Cone = new Cone(new WireframeMaterial(0x00FF00), 10, 20, 4);
		yCone.y = radius;
		yCone.rotationX = -180;
		_cones.push(addChild(yCone));

		var zCone:Cone = new Cone(new WireframeMaterial(0x0000FF), 10, 20, 4);
		zCone.z = radius;
		zCone.rotationX = -90;
		_cones.push(addChild(zCone));

		if (hasNegativeTrident)
		{
			var _xCone:Cone = new Cone(new WireframeMaterial(0x660000), 10, 20, 4);
			_xCone.x = -radius;
			_xCone.rotationZ = -90;
			_cones.push(addChild(_xCone));

			var _yCone:Cone = new Cone(new WireframeMaterial(0x006600), 10, 20, 4);
			_yCone.y = -radius;
			_cones.push(addChild(_yCone));

			var _zCone:Cone = new Cone(new WireframeMaterial(0x000066), 10, 20, 4);
			_zCone.z = -radius;
			_zCone.rotationX = 90;
			_cones.push(addChild(_zCone));
		}

		for (i in 0..._cones.length)
		{
			var _cone = _cones[i];
			_cone.bothsides = true;
			_cone.mouseEnabled = false;
		}
	}
}