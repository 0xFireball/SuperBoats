package sprites;

import kha.Color;

import n4.math.NPoint;
import n4.math.NVector;
import n4.math.NAngle;
import n4.NGame;

import sprites.projectiles.*;

class PlayerBoat extends Boat {
	private static var attackTime:Float = 1.0;
	private var attackTimer:Float = 0;
	private var attackCount:Int = 0;

	private var attacking:Bool = false;

	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);
		angularThrust = 0.05 * Math.PI;
		thrust = 3.5;
		wrapBounds = false;
		mass = 8000;
		sprayAmount = 8;
		renderGraphic(16, 36, function (gpx) {
			var ctx = gpx.g2;
			ctx.begin();
			ctx.color = Color.fromFloats(0.1, 0.3, 0.9);
			ctx.fillRect(0, 0, width, height);
			ctx.color = Color.fromFloats(0.1, 0.5, 0.9);
			ctx.fillRect(width / 3, height * (3 / 4), width / 3, height / 4);
			ctx.end();
		}, "playerboat");
	}

	override public function update(dt:Float) {
		movement();
		attackTimer += dt;
		if (attackTimer > attackTime && attacking) {
			attack();
			++attackCount;
			attackTimer = 0;
		}

		super.update(dt);
	}

	public function attack() {
		var velOpp = velocity.toVector().normalize().rotate(new NPoint(0, 0), 180).scale(20);
		var fTalon = new Talon(x + velOpp.x, y + velOpp.y, Registry.PS.mothership, true);
		Registry.PS.playerProjectiles.add(fTalon);
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

		attacking = NGame.keys.pressed(["F"]);
	}
}