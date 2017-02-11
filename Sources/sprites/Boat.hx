package sprites;

import n4.NGame;
import n4.math.NPoint;
import n4.effects.particles.NParticleEmitter;
import n4.entities.NSprite;
import n4.util.NColorUtil;

class Boat extends NSprite {
	public var angularThrust(default, null):Float = 0.05 * Math.PI;
	public var thrust(default, null):Float = 3.5;
	
	private var wrapBounds:Bool = true;

	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);

		maxVelocity.set(200, 200);
		maxAngular = Math.PI;
		angularDrag = Math.PI;
		drag.set(15, 15);
	}

	override public function update(dt:Float) {
		keepInBounds();
		drawSpray();
		super.update(dt);
	}

	private function drawSpray() {
		var particleTrailVector = velocity.toVector(); // duplicate velocity vector
		particleTrailVector.rotate(new NPoint(0, 0), 180);
		particleTrailVector.scale(0.7);

		for (i in 0...5) {
			Registry.currentEmitterState.emitter.emitSquare(center.x, center.y, Std.int(Math.random() * 10),
				NParticleEmitter.velocitySpread(40, particleTrailVector.x, particleTrailVector.y),
			NColorUtil.randCol(0.2, 0.6, 0.8, 0.2), Math.random() * 1.0);
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