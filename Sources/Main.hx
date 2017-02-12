package;

import n4.NGame;
import states.IntroState;

class Main {
	public static function main() {
		NGame.init("SuperBoats", 
		#if sys_html5
			0, 0,
		#else
			1024, 768,
		#end
			IntroState);
	}
}
