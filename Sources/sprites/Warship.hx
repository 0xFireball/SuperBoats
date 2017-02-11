package sprites;

import kha.Color;

import n4.math.NPoint;
import n4.math.NVector;
import n4.math.NAngle;
import n4.NGame;

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

	override public function update(dt:Float) {
		movement();

		super.update(dt);
	}

	private function movement() {
		var left = false;
		var up = false;
		var right = false;
		var down = false;


		// forward is in the direction the boat is pointing
		var facingAngle = angle; // facing upward

		// process AI logic
		if (x < NGame.width / 4 || x > NGame.width * (3 / 4) || y < NGame.height / 4 || y > NGame.height * (3 / 4)) {
			// if going near the edge, point to the center
			// create an angle from the current position to the center
			var angleToCenter = new NVector(x, y).angleBetween(new NPoint(NGame.width / 2, NGame.height / 2));
			if (Math.abs(facingAngle - angleToCenter) > Math.PI / 6) {
				if (facingAngle < angleToCenter) {
					right = true;
				} else if (facingAngle > angleToCenter) {
					left = true;
				}
			}
			up = true;
		}

		// cancel movement
		if (left && right) left = right = false;
		if (up && down) up = down = false;

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