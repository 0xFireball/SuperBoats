package sprites;

import n4.NGame;
import n4.math.NPoint;
import n4.effects.particles.NParticleEmitter;
import n4.entities.NSprite;
import n4.math.NAngle;
import n4.util.NColorUtil;
import n4.math.NVector;

class Boat extends NSprite {
	public var angularThrust(default, null):Float = 0.05 * Math.PI;
	public var thrust(default, null):Float = 3.5;
	public var sprayAmount(default, null):Int = 5;
	public var spraySpread(default, null):Int = 40;
	
	private var wrapBounds:Bool = true;

	public var hullShieldMax:Float = 60000;
	public var hullShieldIntegrity:Float = 0;
	public var hullShieldRegen:Float = 100;

	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);
		
		maxHealth = health = 100000;
		maxVelocity.set(200, 200);
		maxAngular = Math.PI;
		angularDrag = Math.PI;
		drag.set(24, 24);
		elasticity = 0.3;
		mass = 16000;
	}

	override public function update(dt:Float) {
		keepInBounds();
		drawSpray();
		manageHealth();
		powerShield();

		super.update(dt);
	}

	private function moveDefault(Thrust:Bool, Left:Bool, Right:Bool, Brake:Bool) {
		// cancel movement
		if (Left && Right) Left = Right = false;
		if (Thrust && Brake) Thrust = Brake = false;

		if (Left) {
			angularVelocity -= angularThrust;
		} else if (Right) {
			angularVelocity += angularThrust;
		}
		var thrustVector = new NVector(0, 0);
		drag.set(15, 15);
		if (Thrust) {
			thrustVector.add(0, -thrust);
		} else if (Brake) {
			// thrustVector.add(0, thrust);
			// brakes
			drag.scale(6);
		}
		thrustVector.rotate(new NPoint(0, 0), NAngle.asDegrees(angle));
		velocity.addPoint(thrustVector);
	}

	private function powerShield() {
		if (hullShieldIntegrity > 0) {
			hullShieldIntegrity += hullShieldRegen;
			if (hullShieldIntegrity > hullShieldMax) hullShieldIntegrity = hullShieldMax;
		}
	}

	override public function hurt(amount:Float) {
		// apply damage to shield, else health
		if (hullShieldIntegrity > 0) {
			// absorb damage into shield
			hullShieldIntegrity -= amount;
			if (hullShieldIntegrity < 0) hullShieldIntegrity = 0;
		} else {
			super.hurt(amount);
		}
	}

	private function manageHealth() {
		if (damage > 0.2 && damage <= 0.5) {
			// smoke
			for (i in 0...Std.int(4 * damage)) {
				Registry.PS.explosionEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 6 + 3),
					NParticleEmitter.velocitySpread(90),
				NColorUtil.randCol(0.3, 0.3, 0.3, 0.05), 1.8);
			}
		} else if (damage > 0.5 && damage <= 0.7) {
			// fire
			for (i in 0...Std.int(8 * damage)) {
				Registry.PS.explosionEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 6 + 3),
					NParticleEmitter.velocitySpread(90),
				NColorUtil.randCol(0.8, 0.5, 0.2, 0.2), 1.8);
			}
		} else if (damage > 0.7) {
			// bright fire
			for (i in 0...Std.int(12 * damage)) {
				Registry.PS.explosionEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 6 + 3),
					NParticleEmitter.velocitySpread(90),
				NColorUtil.randCol(0.9, 0.3, 0.2, 0.1), 2.2);
			}
		}

		if (damage >= 1) {
			// dead!
			explode();
			destroy();
		}
	}

	private function drawSpray() {
		var particleTrailVector = velocity.toVector(); // duplicate velocity vector
		particleTrailVector.rotate(new NPoint(0, 0), 180);
		particleTrailVector.scale(0.7);

		for (i in 0...sprayAmount) {
			Registry.PS.lowerEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 10) + 1,
				NParticleEmitter.velocitySpread(spraySpread, particleTrailVector.x, particleTrailVector.y),
			NColorUtil.randCol(0.2, 0.6, 0.8, 0.2), Math.random() * 1.0);
		}
	}

	public function explode() {
		for (i in 0...50) {
			Registry.PS.explosionEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 10) + 1,
				NParticleEmitter.velocitySpread(spraySpread, velocity.x / 4, velocity.y / 4),
			NColorUtil.randCol(0.95, 0.95, 0.1, 0.05), Math.random() * 1.0);
		}
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