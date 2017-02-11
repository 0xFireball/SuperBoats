package sprites;

import kha.Color;

class Warship extends Boat {
	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);
		angularThrust = 0.01 * Math.PI;
		thrust = 1.5;
		wrapBounds = false;
		mass = 84000;
		sprayAmount = 20;
		spraySpread = 80;
		makeGraphic(30, 65, Color.Red);
	}
}