package sprites.projectiles;

import kha.Color;

import n4.entities.NSprite;
import n4.effects.particles.NParticleEmitter;
import n4.util.NColorUtil;
import n4.math.NPoint;
import n4.math.NVector;
import n4.math.NAngle;
import n4.NGame;

class Projectile extends NSprite {
	public var movementSpeed:Float = 100;
	public var target:NSprite;

	/**
	 * The deadliness of the weapon
	 * This should be changed by subclasses
	 */
	public var damageFactor:Float = 10;

	/**
	 * How much to scale the damage by.
	 * Subclasses should not change this.
	 */
	private var damageScale:Float = (1 / 24);

	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);
		mass = 500;
	}

	public function explode() {
		// apply conservation of momentum collision
		var transferredMomentum = this.velocity.toVector().scale(this.mass / target.mass);
		target.velocity.addPoint(transferredMomentum);

		this.destroy();
	}

	public function calculateDamage():Float {
		var dmMomentum = momentum.length;
		return damageFactor * dmMomentum * damageScale;
	}

	public function hitTarget() {
		hitSprite(target);
	}

	public function hitSprite(sprite:NSprite) {
		// deal damage
		var damageDealt = calculateDamage();
		sprite.hurt(damageDealt);
		// trace('dealt ${damageDealt} damage');
		// explode
		explode();
	}

	override public function update(dt:Float) {
		checkBounds();
		super.update(dt);
	}

	private function checkBounds() {
		if (x < width * 2 || y < height * 2 || x > NGame.width + width * 2 || y > NGame.height + height * 2) {
			destroy();
		}
	}
}