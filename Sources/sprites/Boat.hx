package sprites;

import n4.NGame;
import n4.entities.NSprite;

class Boat extends NSprite {
	public var angularThrust(default, null):Float = 0.05 * Math.PI;
	public var thrust(default, null):Float = 20;
	
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
			if (x < width / 2) x = width / 2;
			if (y < height / 2) y = height / 2;
			if (x > NGame.width - width) x = NGame.width - width;
			if (y > NGame.height - height) y = NGame.height - height;
		}
	}
}