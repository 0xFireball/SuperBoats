package ai;

import n4.NState;
import n4.entities.NSprite;

class BoatAiController<T1:NSprite, T2:NSprite> {
	public var triggerRadius:Float;
	public var style:Style;

	public var state(default, null):BoatAiState<T1, T2>;

	public function new() {
	}

	public function loadState(State:BoatAiState<T1, T2>) {
		state = State;
	}

	public function step():ActionState {
		var result = new ActionState();
		return result;
	}

	class ActionState {
		public function new() {}
		public var movement:MovementState;
		public var attack:AttackState;
	}

	class MovementState {
		public function new() {}
		public var brake:Bool;
		public var thrust:Bool;
		public var left:Bool;
		public var right:Bool;
	}

	class AttackState {
		public function new() {}
		public var lightWeapon:Bool;
		public var heavyWeapon:Bool;
	}
}

public enum Style {
	Passive;
	Aggressive;
	Defensive;
}