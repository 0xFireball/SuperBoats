package sprites.projectiles;

import kha.Color;

import n4.entities.NSprite;
import n4.effects.particles.NParticleEmitter;
import n4.util.NColorUtil;
import n4.math.NPoint;
import n4.math.NVector;
import n4.math.NAngle;
import n4.NGame;

class Cannonball extends Projectile {
	public function new(?X:Float = 0, ?Y:Float = 0, Target:NSprite) {
		super(X, Y);
		damageFactor = 1.5;
		mass = 2200;
		target = Target;
		movementSpeed = 180;
		makeGraphic(8, 8, Color.fromFloats(0.6, 0.6, 0.6));
	}

	override public function update(dt:Float) {
		var particleTrailVector = velocity.toVector(); // duplicate velocity vector
		particleTrailVector.rotate(new NPoint(0, 0), 180);
		particleTrailVector.scale(0.7);
		// emit particles
		for (i in 0...2) {
			Registry.currentEmitterState.emitter.emitSquare(center.x, center.y, Std.int(Math.random() * 6) + 1,
				NParticleEmitter.velocitySpread(40, particleTrailVector.x, particleTrailVector.y),
			NColorUtil.randCol(0.5, 0.1, 0.1, 0.1), 0.7);
		}

		super.update(dt);
	}

	override public function explode() {
		for (i in 0...15) {
			Registry.PS.explosionEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 8 + 4),
				NParticleEmitter.velocitySpread(50),
			NColorUtil.randCol(0.8, 0.2, 0.2, 0.2), 1.8);
		}
		for (i in 0...10) {
			Registry.PS.explosionEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 8 + 4),
				NParticleEmitter.velocitySpread(50),
			NColorUtil.randCol(0.8, 0.8, 0.2, 0.2), 1.8);
		}
		super.explode();
	}
}