package sprites;

import kha.Color;

import n4.util.NColorUtil;
import n4.effects.particles.NParticleEmitter;
import n4.math.NPoint;
import n4.math.NVector;
import n4.math.NAngle;
import n4.NGame;
import n4.NG;

import sprites.projectiles.*;

class PlayerBoat extends GreenBoat {
	public var allyCount:Int = 0;
	public var maxAllyCount:Int = 6;

	private var allySpawnFrequency:Int = 400;

	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);

		maxHealth = health = 220000;
		hullShieldMax = hullShieldIntegrity = 72000;
		hullShieldRegen = 100;
		attackTime = 0.7;
		angularThrust = 0.05 * Math.PI;
		thrust = 3.5;
		wrapBounds = false;
		mass = 28000;
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
		spawnAllies();

		super.update(dt);
	}

	private function spawnAllies() {
		if (allyCount < maxAllyCount && Std.int(Math.random() * allySpawnFrequency) == 4) {
			// spawn ally
			++allyCount;
			var ally = new GreenBoat(0, Math.random() * NGame.height);
			Registry.PS.allies.add(ally);
		}
	}

	override private function movement() {
		var up:Bool = false;
		var left:Bool = false;
		var right:Bool = false;
		var down:Bool = false;

		left = NG.keys.pressed(["J", "LEFT"]);
		up = NG.keys.pressed(["I", "UP"]);
		right = NG.keys.pressed(["L", "RIGHT"]);
		down = NG.keys.pressed(["K", "DOWN"]);

		moveDefault(up,
			left,
			right,
			down);

		attacking = NG.keys.pressed(["F", "M"]);
	}
}