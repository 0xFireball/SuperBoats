package ai;

import n4.entities.NSprite;
import n4.group.NTypedGroup;

class BoatAiState<T1:NSprite, T2:NSprite> {
	public var friends(default, null):NTypedGroup<T1>;
	public var enemies(default, null):NTypedGroup<T2>;
}