package sprites;

import n4.NGame;
import n4.entities.NSprite;

class Boat extends NSprite {
	public var angularThrust(default, null):Float = 0.2 * Math.PI;
	public var thrust(default, null):Float = 2;
	
	private var wrapBounds:Bool = true;

	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);

		maxVelocity.set(200, 200);
		maxAngular = Math.PI * 4;
		angularDrag = Math.PI;
		drag.set(20, 20);
	}

	override public function update(dt:Float) {
		keepInBounds();	
		super.update(dt);
	}

	private function keepInBounds() {
		if (wrapBounds) {
			if (x < 0) x += NGame.width;
			if (y < 0) y += NGame.height;
			if (x > NGame.width) x %= NGame.width;
			if (y > NGame.height) y %= NGame.height;
		} else {
			if (x < 0) x = 0;
			if (y < 0) y = 0;
			if (x > NGame.width) x = NGame.width;
			if (y > NGame.height) y = NGame.height;
		}
	}
}