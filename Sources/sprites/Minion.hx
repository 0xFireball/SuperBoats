package sprites;

import kha.Color;

import ai.BoatAiController;

class Minion extends Warship {
	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);
		maxHealth = health = 540000;
		thrust = 1.9;
		wrapBounds = false;
		mass = 79000;
		sprayAmount = 20;
		spraySpread = 80;
		angularThrust = 0.032 * Math.PI;
		maxAngular = Math.PI / 4;
		maxVelocity.set(135, 135);
		renderGraphic(20, 43, function (gpx) {
			var ctx = gpx.g2;
			ctx.begin();
			ctx.color = Color.fromFloats(0.8, 0.4, 0.1);
			ctx.fillRect(0, 0, width, height);
			ctx.color = Color.fromFloats(0.9, 0.5, 0.1);
			ctx.fillRect(width / 3, height * (3 / 4), width / 3, height / 4);
			ctx.end();
		}, "minion_warship");
	}

	override public function update(dt:Float) {
		aiController.style = damage < 0.7 ? Aggressive : Defensive;

		super.update(dt);
	}

	override public function destroy() {
		// when destroyed, update minion count
		Registry.PS.mothership.minionCount--;
		super.destroy();
	}
}