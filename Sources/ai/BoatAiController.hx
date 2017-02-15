package ai;

import n4.entities.NSprite;
import n4.math.NPoint;
import n4.math.NVector;
import n4.math.NAngle;
import n4.NGame;

class BoatAiController<T1:NSprite, T2:NSprite> {
	public var triggerRadius:Float;
	public var style:Style = Passive;
	public var me:NSprite;
	public var target:NSprite;

	public var state(default, null):BoatAiState<T1, T2>;

	public function new() {
	}

	public function loadState(State:BoatAiState<T1, T2>) {
		state = State;
	}

	public function step():ActionState {
		var result = new ActionState();

		var left = false;
		var up = false;
		var right = false;
		var down = false;
		// forward is in the direction the boat is pointing
		var facingAngle = me.angle; // facing upward
		var selfPosition = new NVector(me.x, me.y);

		// process AI logic
		// if going near the edge, point to the center
		var chaseRadius = NGame.hypot / 4;
		var targetSetpoint:NVector = null;
		if (target != null) {
			var targetPos = target.center.toVector();
			if (style == Aggressive || (selfPosition.distanceTo(targetPos) > chaseRadius)) {
				targetSetpoint = targetPos;
			}
		} else if (me.x < NGame.width / 4 || me.x > NGame.width * (3 / 4)
			|| me.y < NGame.height / 4 || me.y > NGame.height * (3 / 4)) {
			targetSetpoint = new NVector(NGame.width / 2, NGame.height / 2);
		}

		if (targetSetpoint != null) {
			var distToTarget = new NVector(me.x, me.y).subtractNew(targetSetpoint);
			// create an angle from the current position to the center
			var angleToSetpoint = NAngle.asRadians(new NVector(me.x, me.y).angleBetween(targetSetpoint));
			if (Math.abs(facingAngle - angleToSetpoint) > Math.PI / 8) {
				if (facingAngle < angleToSetpoint) {
					right = true;
				} else if (facingAngle > angleToSetpoint) {
					left = true;
				}
			} else {
				// we're on target
				if (style == Aggressive) {
					up = true;
				} else if (distToTarget.length > chaseRadius * (2 / 3)) {
					up = true;
				}
			}
		}
		result.movement.thrust = up;
		result.movement.brake = down;
		result.movement.left = left;
		result.movement.right = right;
		return result;
	}
}

enum Style {
	Passive;
	Aggressive;
	Defensive;
}

class ActionState {
	public function new() {}
	public var movement:MovementState = new MovementState();
	public var attack:AttackState = new AttackState();
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