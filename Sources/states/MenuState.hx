package states;

import n4.NGame;
import n4.group.NTypedGroup;
import n4.effects.particles.NSquareParticleEmitter;
import n4.NState;
import n4e.ui.NEText;
import n4.util.NAxes;

using tweenxcore.Tools;

import sprites.DummyBoat;

class MenuState extends NState {
	private var dummyBoats:NTypedGroup<DummyBoat>;
	private var titleText:NEText;
	public var emitter:NSquareParticleEmitter;

	override public function create() {
		Registry.MS = this;
		
		// add dummy boats
		dummyBoats = new NTypedGroup<DummyBoat>();
		for (i in 0...Std.int(Math.random() * 6) + 1) {
			var dummyBoat = new DummyBoat(Math.random() * NGame.width, Math.random() * NGame.height);
			dummyBoats.add(dummyBoat);
		}
		add(dummyBoats);

		emitter = new NSquareParticleEmitter(200);
		add(emitter);

		titleText = new NEText(0, NGame.height * 0.2, "SuperBoats", 50);
		titleText.screenCenter(NAxes.X);
		add(titleText);

		var madeWithText = new NEText(0, 0, "made with n4 engine", 32);
		madeWithText.x = NGame.width - madeWithText.width * 1.2;
		madeWithText.y = NGame.height - madeWithText.height * 1.4;

		add(madeWithText);
	}

	override public function update(dt:Float) {
		if (NGame.updateFrameCount % NGame.targetFramerate * 6 == 0) {
			dummyBoats.forEachActive(function (d) {
				d.randomizeMotion();
			});
		}

		titleText.color.A = 0.85 
			+ 0.1 * Math.sin(NGame.updateFrameCount / 8) 
			+ 0.05 * Math.sin(NGame.updateFrameCount / (Math.random() * 10));
		
		// NGame.collide(dummyBoats, dummyBoats);
		super.update(dt);
	}
}