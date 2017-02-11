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

	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);
	}

	public function explode() {
		this.destroy();
	}
}