package;

import kha.Font;

import n4.NGame;

import states.*;

class Registry {
	public static var mainFont:Font;
	public static var MS:MenuState;
	public static var PS:PlayState;
	public static var currentEmitterState(get, null):IEmitterState;

	public static function get_currentEmitterState():IEmitterState {
		return cast (NGame.currentState, IEmitterState);
	}
}