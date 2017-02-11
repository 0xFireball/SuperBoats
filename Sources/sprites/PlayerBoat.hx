package sprites;

import kha.Color;

class PlayerBoat extends Boat {
	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);
		makeGraphic(16, 36, Color.Blue);
	}
}