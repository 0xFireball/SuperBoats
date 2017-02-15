package states;

import kha.Assets;
import kha.Color;

import n4.NGame;
import n4.NState;
import n4.effects.particles.NParticleEmitter;
import n4.entities.NSprite;
import n4.util.NColorUtil;
import n4.util.NAxes;
import n4e.ui.NEText;

class YouWonState extends NState {

	public var emitter:NParticleEmitter;

	override public function create() {		
		var titleText = new NEText(20, 20, "SuperBoats", 35, Color.White);
		add(titleText);

		emitter = new NParticleEmitter(200);
		add(emitter);

		var pbt = new NEText(0, NGame.height * 0.65, "you won. level " + Registry.levelNum, 32);
		pbt.screenCenter(NAxes.X);
		add(pbt);

		var howToStartText = new NEText(0, NGame.height * 0.75, "press G to retry, press H to level up", 20);
		howToStartText.screenCenter(NAxes.X);
		add(howToStartText);

		super.create();
	}

	override public function update(dt:Float) {
		// bright green
		for (i in 0...12) {
			emitter.emitSquare(NGame.width / 2, NGame.height / 2, Std.int(Math.random() * 6 + 3),
				NParticleEmitter.velocitySpread(120),
			NColorUtil.randCol(0.1, 0.9, 0.2, 0.1), 2.2);
		}

		if (NGame.keys.justPressed(["H"])) {
			// challenge mode
			Registry.levelNum = 1;
			// reopen menu
			NGame.switchState(Registry.MS);
		}
		if (NGame.keys.justPressed(["G"])) {
			// reopen menu
			NGame.switchState(Registry.MS);
		}

		super.update(dt);
	}
}