package sprites;

import kha.Color;

import n4.NGame;

class Mothership extends Warship {

	private var minionSpawnChance = 720;
	public var minionCount:Int = 0;
	public var maxMinionCount:Int = 2;

	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);
		maxHealth = health = 4750000;
		thrust = 0.6;
		wrapBounds = false;
		mass = 184000;
		sprayAmount = 20;
		spraySpread = 80;
		angularThrust = 0.027 * Math.PI;
		maxAngular = Math.PI / 5;
		maxVelocity.set(60, 60);

		if (Registry.levelNum > 0) {
			health *= (Registry.levelNum + 2);
			maxHealth = health;
			hullShieldMax = hullShieldIntegrity = 180000 * Registry.levelNum;
			hullShieldRegen = 2 + (Registry.levelNum - 1) * 2;
		}
		
		renderGraphic(30, 65, function (gpx) {
			var ctx = gpx.g2;
			ctx.begin();
			ctx.color = Color.fromFloats(0.9, 0.3, 0.1);
			ctx.fillRect(0, 0, width, height);
			ctx.color = Color.fromFloats(0.9, 0.5, 0.1);
			ctx.fillRect(width / 3, height * (3 / 4), width / 3, height / 4);
			ctx.end();
		}, "main_warship");
	}

	override public function update(dt:Float) {
		if (damage > 0.44 && minionCount < maxMinionCount && Std.int(Math.random() * minionSpawnChance) == 4) {
			minionCount++;
			var minionDist = NGame.hypot / 4;
			var minion = new Minion(center.x + Math.random() * minionDist, center.y + Math.random() * minionDist);
			minion.velocity.set(Math.random() * 100, Math.random() * 100);
			Registry.PS.warships.add(minion);
		}

		super.update(dt);
	}
}