package sprites;

import kha.Color;

import n4.util.NColorUtil;
import n4.effects.particles.NParticleEmitter;
import n4.math.NPoint;
import n4.math.NVector;
import n4.math.NAngle;
import n4.NGame;

import ai.BoatAiState;
import ai.BoatAiController;
import sprites.projectiles.*;

class GreenBoat extends Boat {
	private var attackTime:Float = 1.0;
	private var attackTimer:Float = 0;
	private var attackCount:Int = 0;

	public var aiController:BoatAiController<GreenBoat, Warship>;
	public var aiState:BoatAiState<GreenBoat, Warship>;
	public var attacking:Bool = false;
	public var lastStep:ActionState;

	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);

		aiController = new BoatAiController<GreenBoat, Warship>();
		aiController.me = this;
		aiState = new BoatAiState<GreenBoat, Warship>();
		aiController.loadState(aiState);
		maxHealth = health = 170000;
		hullShieldMax = hullShieldIntegrity = 57000;
		hullShieldRegen = 100;
		attackTime = 0.7;
		angularThrust = 0.05 * Math.PI;
		thrust = 3.5;
		wrapBounds = false;
		mass = 26000;
		maxVelocity.set(200, 200);
		sprayAmount = 8;
		renderGraphic(14, 32, function (gpx) {
			var ctx = gpx.g2;
			ctx.begin();
			ctx.color = Color.fromFloats(0.1, 0.9, 0.3);
			ctx.fillRect(0, 0, width, height);
			ctx.color = Color.fromFloats(0.1, 0.9, 0.5);
			ctx.fillRect(width / 3, height * (3 / 4), width / 3, height / 4);
			ctx.end();
		}, "greenboat");
	}

	override public function update(dt:Float) {
		movement();
		attackTimer += dt;
		if (attackTimer > attackTime && lastStep.attack.anyWeapon) {
			autoFire();
			++attackCount;
			attackTimer = 0;
		}

		super.update(dt);
	}

	public function autoFire() {
		var target = acquireTarget();
		if (target == null) return;
		var velOpp = velocity.toVector().normalize().rotate(new NPoint(0, 0), 180).scale(20);
		var fTalon = new Talon(x + velOpp.x, y + velOpp.y, target, false);
		// target talon
		var tVec = fTalon.center.toVector()
			.subtractPoint(target.center)
			.rotate(new NPoint(0, 0), 180)
			.toVector().normalize().scale(fTalon.movementSpeed);
		fTalon.velocity.set(tVec.x, tVec.y);
		// apply recoil
		velocity.addPoint(fTalon.momentum.scale(1 / mass).negate());
		Registry.PS.playerProjectiles.add(fTalon);
	}

	private function acquireTarget():Warship {
		var target:Warship = null;
		var minDistance = NGame.hypot * 2;
		Registry.PS.warships.forEachActive(function (boat) {
			var dist = boat.center.distanceTo(center);
			if (dist < minDistance) {
				minDistance = dist;
				target = boat;
			}
		});
		return target;
	}

	private function movement() {
		// minion should attack
		var left = false;
		var up = false;
		var right = false;
		var down = false;

		var target = acquireTarget();
		aiState.friends = Registry.PS.allies;
		aiState.enemies = Registry.PS.warships;
		aiController.target = target;

		var step = aiController.step();
		lastStep = step;
		up = step.movement.thrust;
		down = step.movement.brake;
		left = step.movement.left;
		right = step.movement.right;

		// cancel movement
		if (left && right) left = right = false;
		if (up && down) up = down = false;

		if (left) {
			angularVelocity -= angularThrust;
		} else if (right) {
			angularVelocity += angularThrust;
		}
		var thrustVector = new NVector(0, 0);
		drag.set(15, 15);
		if (up) {
			thrustVector.add(0, -thrust);
		} else if (down) {
			// thrustVector.add(0, thrust);
			// brakes
			drag.scale(6);
		}
		thrustVector.rotate(new NPoint(0, 0), NAngle.asDegrees(angle));
		velocity.addPoint(thrustVector);	
	}

	override public function destroy() {
		if (this != Registry.PS.player) {
			Registry.PS.player.allyCount--;
		}
		super.destroy();
	}
}