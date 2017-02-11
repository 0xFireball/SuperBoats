package states;

import kha.Color;

import n4.math.NPoint;
import n4.NGame;
import n4.entities.NSprite;
import n4.effects.particles.NSquareParticleEmitter;
import n4.NState;
import n4e.ui.NEText;
import n4.util.NAxes;

class MenuState extends NState {
	private var dummyBoat:NSprite;
	private var emitter:NSquareParticleEmitter;

	override public function create() {
		var titleText = new NEText(0, NGame.height * 0.2, "SuperBoats", 50);
		titleText.screenCenter(NAxes.X);
		add(titleText);

		var madeWithText = new NEText(0, 0, "made with n4 engine", 32);
		madeWithText.x = NGame.width - madeWithText.width * 1.2;
		madeWithText.y = NGame.height - madeWithText.height * 1.4;

		// add dummy boat
		dummyBoat = new NSprite(Math.random() * NGame.width, Math.random() * NGame.height);
		dummyBoat.makeGraphic(10, 24, Color.Blue);
		dummyBoat.maxVelocity.set(200, 200);
		dummyBoat.maxAngular = Math.PI * (0.5);
		// starting acceleration
		dummyBoat.acceleration.y = -20;
		add(dummyBoat);

		emitter = new NSquareParticleEmitter(200);
		add(emitter);

		add(madeWithText);
	}

	override public function update(dt:Float) {
		if (dummyBoat.x < 0) dummyBoat.x += NGame.width;
		if (dummyBoat.y < 0) dummyBoat.y += NGame.height;
		if (dummyBoat.x > NGame.width) dummyBoat.x %= NGame.width;
		if (dummyBoat.y > NGame.height) dummyBoat.y %= NGame.height;
		if (NGame.updateFrameCount % NGame.targetFramerate * 6 == 0) {
			dummyBoat.acceleration.y = Math.random() * -90;
			dummyBoat.acceleration.rotate(new NPoint(0, 0), Math.random() * 360);
			dummyBoat.angularAcceleration = Math.random() * Math.PI / 5;
		}

		var particleTrailVector = dummyBoat.velocity.toVector(); // duplicate velocity vector
		particleTrailVector.rotate(new NPoint(0, 0), 180);
		particleTrailVector.scale(0.7);

		emitter.emit(dummyBoat.center.x, dummyBoat.center.y, 2,
			NSquareParticleEmitter.velocitySpread(20, particleTrailVector.x, particleTrailVector.y),
			Color.Blue, 1.0);

		super.update(dt);
	}
}