package sprites;

import kha.Color;

import n4.util.NColorUtil;
import n4.effects.particles.NParticleEmitter;
import n4.math.NPoint;
import n4.math.NVector;
import n4.math.NAngle;
import n4.NGame;

class GreenBoat extends Boat {
	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);

		maxHealth = health = 170000;
		hullShieldMax = hullShieldIntegrity = 54000;
		hullShieldRegen = 100;
		angularThrust = 0.05 * Math.PI;
		thrust = 3.5;
		wrapBounds = false;
		mass = 26000;
		sprayAmount = 8;
		renderGraphic(14, 32, function (gpx) {
			var ctx = gpx.g2;
			ctx.begin();
			ctx.color = Color.fromFloats(0.1, 0.9, 0.3);
			ctx.fillRect(0, 0, width, height);
			ctx.color = Color.fromFloats(0.1, 0.9, 0.5);
			ctx.fillRect(width / 3, height * (3 / 4), width / 3, height / 4);
			ctx.end();
		}, "greenboat");
	}

	override public function update(dt:Float) {
		movement();

		super.update(dt);
	}

	private function movement() {
		
	}

	override public function destroy() {
		if (this != Registry.PS.player) {
			Registry.PS.player.allyCount--;
		}
		super.destroy();
	}
}