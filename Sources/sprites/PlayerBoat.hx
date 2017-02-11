package sprites;

import kha.Color;

import n4.math.NPoint;
import n4.math.NVector;
import n4.math.NAngle;
import n4.NGame;

class PlayerBoat extends Boat {
	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);
		wrapBounds = false;
		makeGraphic(16, 36, Color.Blue);
	}

	override public function update(dt:Float) {
		movement();

		super.update(dt);
	}

	private function movement() {
		var left = false;
		var up = false;
		var right = false;
		var down = false;

		left = NGame.keys.pressed(["A", "LEFT"]);
		up = NGame.keys.pressed(["W", "UP"]);
		right = NGame.keys.pressed(["D", "RIGHT"]);
		down = NGame.keys.pressed(["S", "DOWN"]);

		// cancel movement
		if (left && right) left = right = false;
		if (up && down) up = down = false;

		// forward is in the direction the boat is pointing
		var facingAngle = angle; // facing upward
		if (left) {
			angularVelocity -= angularThrust;
		} else if (right) {
			angularVelocity += angularThrust;
		}
		var thrustVector = new NVector(0, 0);
		drag.set(15, 15);
		if (up) {
			thrustVector.add(0, -thrust);
		} else if (down) {
			// thrustVector.add(0, thrust);
			// brakes
			drag.scale(6);
		}
		thrustVector.rotate(new NPoint(0, 0), NAngle.asDegrees(facingAngle));
		velocity.addPoint(thrustVector);
	}
}