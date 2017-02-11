package sprites;

import kha.Color;

import n4.math.NPoint;
import n4.math.NVector;
import n4.math.NAngle;
import n4.NGame;

class Warship extends Boat {
	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);
		angularThrust = 0.03 * Math.PI;
		thrust = 0.5;
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
			var fieldCenter = new NVector(NGame.width / 2, NGame.height / 2);
			var distToCenter = new NVector(x, y).subtractNew(fieldCenter);
			// create an angle from the current position to the center
			var angleToCenter = NAngle.asRadians(new NVector(x, y).angleBetween(fieldCenter));
			if (Math.abs(facingAngle - angleToCenter) > Math.PI / 8) {
				if (facingAngle < angleToCenter) {
					right = true;
				} else if (facingAngle > angleToCenter) {
					left = true;
				}
			}
			var fieldHypot = Math.sqrt(NGame.width * NGame.width + NGame.height * NGame.height);
			if (distToCenter.length > fieldHypot / 4) {
				up = true;
			}
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