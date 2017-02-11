package sprites;

import n4.entities.NSprite;

class Boat extends NSprite {
	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);

		maxVelocity.set(200, 200);
		angularDrag = Math.PI / 4;
		drag.set(20, 20);
	}
}