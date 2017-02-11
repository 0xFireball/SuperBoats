package sprites;

import kha.Color;

import n4.math.NPoint;
import n4.NGame;
import n4.entities.NSprite;
import n4.effects.particles.NSquareParticleEmitter;
import n4.NState;
import n4e.ui.NEText;
import n4.util.NAxes;

class DummyBoat extends NSprite {
	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);

		makeGraphic(10, 24, Color.Blue);
		maxVelocity.set(200, 200);
		maxAngular = Math.PI * (0.5);
		randomizeMotion();
	}

	override public function update(dt:Float) {
		var particleTrailVector = velocity.toVector(); // duplicate velocity vector
		particleTrailVector.rotate(new NPoint(0, 0), 180);
		particleTrailVector.scale(0.7);

		Registry.MS.emitter.emit(center.x, center.y, 2,
			NSquareParticleEmitter.velocitySpread(20, particleTrailVector.x, particleTrailVector.y),
			Color.Blue, 1.0);

		if (x < 0) x += NGame.width;
		if (y < 0) y += NGame.height;
		if (x > NGame.width) x %= NGame.width;
		if (y > NGame.height) y %= NGame.height;

		super.update(dt);
	}

	public function randomizeMotion() {
		acceleration.y = Math.random() * -90;
		acceleration.rotate(new NPoint(0, 0), Math.random() * 360);
		angularAcceleration = Math.random() * Math.PI / 5;
	}
}