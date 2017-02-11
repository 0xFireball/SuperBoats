package sprites;

import kha.Color;

class Warship extends Boat {
	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);
		makeGraphic(30, 65, Color.Red);
	}
}