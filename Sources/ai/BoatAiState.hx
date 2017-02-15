package ai;

import n4.entities.NSprite;
import n4.group.NTypedGroup;

class BoatAiState<T1:NSprite, T2:NSprite> {
	public function new() {}
	public var friends:NTypedGroup<T1>;
	public var enemies:NTypedGroup<T2>;
}