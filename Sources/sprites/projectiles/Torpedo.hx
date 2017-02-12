package sprites.projectiles;

import kha.Color;

import n4.entities.NSprite;
import n4.effects.particles.NParticleEmitter;
import n4.util.NColorUtil;
import n4.math.NPoint;
import n4.math.NVector;
import n4.math.NAngle;
import n4.NGame;

class Torpedo extends Projectile {
	public var thrust(default, null):Float = 6;
	public var angularThrust(default, null):Float = Math.PI * 0.08;

	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);
		movementSpeed = 90;
		maxVelocity.set(600, 600);
		makeGraphic(5, 5, Color.fromFloats(0.6, 0.9, 0.6));
	}

	override public function update(dt:Float) {
		var particleTrailVector = velocity.toVector(); // duplicate velocity vector
		particleTrailVector.rotate(new NPoint(0, 0), 180);
		particleTrailVector.scale(0.7);
		// emit trail particles
		for (i in 0...5) {
			Registry.currentEmitterState.emitter.emitSquare(center.x, center.y, Std.int(Math.random() * 6),
				NParticleEmitter.velocitySpread(40, particleTrailVector.x, particleTrailVector.y),
			NColorUtil.randCol(0.4, 0.4, 0.9, 0.1), 0.7);
		}
		// retarget to player
		var mA = 0;
		if (x < Registry.PS.player.x) {
			mA = 0;
			if (y < Registry.PS.player.y) {
				mA += 45;
				angularVelocity += angularThrust;
			} else if (y > Registry.PS.player.y) {
				mA -= 45;
				angularVelocity -= angularThrust;
			}
		} else if (x > Registry.PS.player.x) {
			mA = 180;
			if (y < Registry.PS.player.y) {
				mA -= 45;
				angularVelocity -= angularThrust;
			} else if (y > Registry.PS.player.y) {
				mA += 45;
				angularVelocity += angularThrust;
			}
		}
		var thrustVector = new NPoint(thrust, 0);
		thrustVector.rotate(new NPoint(0, 0), mA);
		velocity.addPoint(thrustVector);

		super.update(dt);
	}

	override public function explode() {
		for (i in 0...14) {
			Registry.currentEmitterState.emitter.emitSquare(center.x, center.y, Std.int(Math.random() * 10 + 5),
				NParticleEmitter.velocitySpread(90),
			NColorUtil.randCol(0.8, 0.8, 0.2, 0.2), 1.8);
		}
		super.explode();
	}
}