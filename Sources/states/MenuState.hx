package states;

import kha.Assets;

import n4.NGame;
import n4.NState;
import n4e.ui.NEText;
import n4.util.NAxes;

class MenuState extends NState {
	override public function create() {
		var titleText = new NEText(NGame.width / 2, NGame.height * 0.2, "SuperBoats", 40);
		titleText.screenCenter(NAxes.X);
		add(titleText);
	}
}