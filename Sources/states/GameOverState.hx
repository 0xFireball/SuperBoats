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

class GameOverState extends NState {

	public var emitter:NParticleEmitter;

	override public function create() {		
		var titleText = new NEText(20, 20, "SuperBoats", 35, Color.White);
		add(titleText);

		var pbt = new NEText(0, NGame.height * 0.65, "game over", 32);
		pbt.screenCenter(NAxes.X);
		add(pbt);

		emitter = new NParticleEmitter(200);
		add(emitter);

		NGame.timers.setTimer(1400, function() {
			NGame.switchState(Registry.MS);
		});

		super.create();
	}

	override public function update(dt:Float) {
		// bright fire
		for (i in 0...12) {
			emitter.emitSquare(NGame.width / 2, NGame.height / 2, Std.int(Math.random() * 6 + 3),
				NParticleEmitter.velocitySpread(120),
			NColorUtil.randCol(0.9, 0.3, 0.2, 0.1), 2.2);
		}
		super.update(dt);
	}
}