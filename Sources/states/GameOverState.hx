package states;

import kha.Assets;
import kha.Color;

import n4.NGame;
import n4.NState;
import n4.entities.NSprite;
import n4.util.NAxes;
import n4e.ui.NEText;

class GameOverState extends NState {

	override public function create() {		
		var titleText = new NEText(20, 20, "SuperBoats", 35, Color.White);
		add(titleText);

		var pbt = new NEText(0, NGame.height * 0.65, "game over", 32);
		pbt.screenCenter(NAxes.X);
		add(pbt);

		NGame.timers.setTimer(1400, function() {
			NGame.switchState(new MenuState());
		});

		super.create();
	}
}