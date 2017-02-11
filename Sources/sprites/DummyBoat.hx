package sprites;

import kha.Color;

import n4.math.NPoint;
import n4.NGame;
import n4.entities.NSprite;
import n4.effects.particles.NParticleEmitter;
import n4.util.NColorUtil;

class DummyBoat extends NSprite {
	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);

		makeGraphic(20, 48, NColorUtil.randCol(0.3, 0.3, 0.7, 0.3));
		maxVelocity.set(200, 200);
		maxAngular = Math.PI * (0.1);
		randomizeMotion();
	}

	override public function update(dt:Float) {
		var particleTrailVector = velocity.toVector(); // duplicate velocity vector
		particleTrailVector.rotate(new NPoint(0, 0), 180);
		particleTrailVector.scale(0.7);

		for (i in 0...5) {
			Registry.MS.emitter.emitSquare(center.x, center.y, Std.int(Math.random() * 10),
				NParticleEmitter.velocitySpread(40, particleTrailVector.x, particleTrailVector.y),
			NColorUtil.randCol(0.2, 0.6, 0.8, 0.2), Math.random() * 1.0);
		}

		if (x < 0) x += NGame.width;
		if (y < 0) y += NGame.height;
		if (x > NGame.width) x %= NGame.width;
		if (y > NGame.height) y %= NGame.height;

		super.update(dt);
	}

	public function randomizeMotion() {
		acceleration.y = Math.random() * -90;
		acceleration.rotate(new NPoint(0, 0), Math.random() * 360);
		angularAcceleration = Math.random() * Math.PI / 20;
	}
}