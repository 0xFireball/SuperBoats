package states;

import kha.Assets;
import kha.Color;

import n4.NGame;
import n4.NState;
import n4.entities.NSprite;
import n4.util.NAxes;
import n4e.ui.NEText;

class IntroState extends NState {

	override public function create() {
		if (Registry.mainFont == null) {
			Registry.mainFont = Assets.fonts.champagneLimousines;
		}

		if (NEText.defaultFont == null) {
			NEText.defaultFont = Registry.mainFont;
		}
		
		var titleText = new NEText(20, 20, "SuperBoats", 35, Color.White);
		add(titleText);

		var spinner = new NSprite();
		spinner.angularVelocity = Math.PI * (3 / 2);
		spinner.renderGraphic(80, 80, function (grx) {
			var ctx = grx.g2;
			ctx.begin();
			ctx.color = Color.Red;
			ctx.fillRect(0, 0, 80, 80);
			ctx.end();
		});
		spinner.screenCenter(NAxes.XY);
		add(spinner);

		var pbt = new NEText(0, NGame.height * 0.65, "powered by n4 engine", 32);
		pbt.screenCenter(NAxes.X);
		add(pbt);

		NGame.timers.setTimer(1400, function() {
			NGame.switchState(new MenuState());
		});

		super.create();
	}
}