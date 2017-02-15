package states;

import n4.NGame;
import n4.group.NTypedGroup;
import n4.effects.particles.NParticleEmitter;
import n4.util.NColorUtil;
import n4.NState;
import n4e.ui.NEText;
import n4.util.NAxes;

using tweenxcore.Tools;

import sprites.DummyBoat;

class MenuState extends NState implements IEmitterState {
	private var dummyBoats:NTypedGroup<DummyBoat>;
	private var creationFrame:Int = NGame.updateFrameCount;
	private var titleText:NEText;
	private var titleTextFinalCenter:Float;
	public var emitter(default, null):NParticleEmitter;
	public var effectEmitter:NParticleEmitter;

	override public function create() {
		Registry.MS = this;
		
		emitter = new NParticleEmitter(200);
		add(emitter);

		effectEmitter = new NParticleEmitter(120);
		add(effectEmitter);

		// add dummy boats
		dummyBoats = new NTypedGroup<DummyBoat>();
		for (i in 0...Std.int(Math.random() * 6) + 1) {
			var dummyBoat = new DummyBoat(Math.random() * NGame.width, Math.random() * NGame.height);
			dummyBoats.add(dummyBoat);
		}
		add(dummyBoats);

		titleText = new NEText(0, NGame.height * 0.2, "SuperBoats", 50);
		titleText.screenCenter(NAxes.X);
		titleTextFinalCenter = titleText.x;
		add(titleText);

		var howToStartText = new NEText(0, NGame.height * 0.5, "Press F to play, H for help", 30);
		howToStartText.screenCenter(NAxes.X);
		add(howToStartText);

		var pbt = new NEText(0, NGame.height * 0.67, "level " + Registry.levelNum, 20);
		pbt.screenCenter(NAxes.X);
		add(pbt);

		var madeWithText = new NEText(0, 0, "made with n4 engine", 32);
		madeWithText.x = NGame.width - madeWithText.width * 1.2;
		madeWithText.y = NGame.height - madeWithText.height * 1.4;
		add(madeWithText);


		super.create();
	}

	override public function update(dt:Float) {
		var ttAnimProgress = (NGame.updateFrameCount - creationFrame) / 20;
		if (ttAnimProgress <= 1) titleText.x = ttAnimProgress.backOut().lerp(0, titleTextFinalCenter);

		if (NGame.updateFrameCount % NGame.targetFramerate * 6 == 0) {
			dummyBoats.forEachActive(function (d) {
				d.randomizeMotion();
			});
		}

		if (NGame.keys.justPressed(["F"])) {
			// start game
			// kha.SystemImpl.requestFullscreen();
			startGame();
		}

		if (NGame.keys.justPressed(["H"])) {
			// start game
			NGame.switchState(new HelpState(false));
		}

		// sploosh!
		for (i in 0...12) {
			effectEmitter.emitSquare(NGame.width / 2, NGame.height / 3, Std.int(Math.random() * 7 + 3),
				NParticleEmitter.velocitySpread(420),
			NColorUtil.randCol(0.2, 0.6, 0.8, 0.2), 2.2);
		}

		titleText.color.A = 0.85 
			+ 0.1 * Math.sin(NGame.updateFrameCount / 8) 
			+ 0.05 * Math.sin(NGame.updateFrameCount / (Math.random() * 10));
		
		// NGame.collide(dummyBoats, dummyBoats);
		super.update(dt);
	}

	private function startGame() {
		if (Registry.PS == null) {
			// no saved game
			var shouldShowHelp = !Registry.shownHelp;
			var target = new PlayState();
			if (shouldShowHelp) {
				Registry.shownHelp = true;
				NGame.switchState(new HelpState(true, target));
			} else {
				NGame.switchState(target);
			}
		} else {
			NGame.switchState(Registry.PS);
		}
	}
}