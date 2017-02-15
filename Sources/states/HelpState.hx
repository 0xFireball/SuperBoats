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

class HelpState extends NState {

	public var emitter:NParticleEmitter;

	public var transient:Bool;
	public var nextState:NState;

	public function new(Transient:Bool = false, ?NextState:NState) {
		super();
		transient = Transient;
		nextState = NextState;
	}

	override public function create() {		
		var titleText = new NEText(20, 20, "SuperBoats", 35, Color.White);
		add(titleText);

		emitter = new NParticleEmitter(200);
		add(emitter);

		var pbt = new NEText(20, NGame.height * 0.65, "use the arrow keys or wasd to move. use f or m to shoot.", 26);
		pbt.screenCenter(NAxes.X);
		add(pbt);

		if (transient) {
			NGame.timers.setTimer(1400, function() {
				NGame.switchState(nextState);
			});
		} else {
			var howToStartText = new NEText(0, NGame.height * 0.75, "press F to return", 20);
			howToStartText.screenCenter(NAxes.X);
			add(howToStartText);
		}

		super.create();
	}

	override public function update(dt:Float) {
		// yellow
		for (i in 0...12) {
			emitter.emitSquare(NGame.width / 2, NGame.height / 2, Std.int(Math.random() * 6 + 3),
				NParticleEmitter.velocitySpread(120),
			NColorUtil.randCol(0.9, 0.9, 0.2, 0.1), 2.2);
		}
		if (NGame.keys.justPressed(["F"])) {
			// reopen menu
			NGame.switchState(Registry.MS);
		}

		super.update(dt);
	}
}