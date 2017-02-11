package states;

import kha.Assets;

import n4.NGame;
import n4.NState;
import n4e.ui.NEText;

class IntroState extends NState {

	override public function create() {
		if (Registry.mainFont == null) {
			Registry.mainFont = Assets.fonts.champagneLimousines;
		}

		if (NEText.font == null) {
			NEText.font = Registry.mainFont;
		}
		
		var titleText = new NEText(20, 20, "SuperBoats", 40);
		add(titleText);

		NGame.timers.setTimer(400, function() {
			NGame.switchState(new MenuState());
		});

		super.create();
	}
}