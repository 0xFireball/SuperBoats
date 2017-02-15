package sprites;

import kha.Color;

import n4.math.NPoint;
import n4.math.NVector;
import n4.math.NAngle;
import n4.NGame;
import n4.effects.particles.NParticleEmitter;
import n4.util.NColorUtil;

import ai.BoatAiState;
import ai.BoatAiController;
import sprites.projectiles.*;

class Warship extends Boat {
	private static var attackTime:Float = 0.2;
	private var attackTimer:Float = 0;
	private var attackCount:Int = 0;
	private var cannonMissRange:Float = Math.PI * 1 / 8;
	private var torpedoMissRange:Float = Math.PI * 1 / 3;
	public var aiController:BoatAiController<Warship, GreenBoat>;
	public var aiState:BoatAiState<Warship, GreenBoat>;

	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);
		aiController = new BoatAiController<Warship, GreenBoat>();
		aiController.me = this;
		aiState = new BoatAiState<Warship, GreenBoat>();
		aiController.loadState(aiState);
		maxHealth = health = 4750000;
		thrust = 0.6;
		wrapBounds = false;
		mass = 184000;
		sprayAmount = 20;
		spraySpread = 80;
		angularThrust = 0.027 * Math.PI;
		maxAngular = Math.PI / 5;
		maxVelocity.set(60, 60);
	}

	override public function update(dt:Float) {
		movement();
		attackTimer += dt;
		if (attackTimer > attackTime) {
			attackPlayer();
			++attackCount;
			attackTimer = 0;
		}

		super.update(dt);
	}

	private function acquireTarget():GreenBoat {
		var target:GreenBoat = null;
		var minDistance = NGame.hypot * 2;
		Registry.PS.allies.forEachActive(function (boat) {
			var dist = boat.center.distanceTo(center);
			if (dist < minDistance) {
				minDistance = dist;
				target = boat;
			}
		});
		return target;
	}

	private function attackPlayer() {
		var target = acquireTarget();
		if (target == null) return;
		var dist = center.toVector().subtractPoint(target.center);
		var dx = dist.x;
		var dy = dist.y;
		if (attackCount % 3 == 0) {
			var projectile:Projectile = null;
			projectile = new Cannonball(x + width / 2, y + height / 2, target);
			var bulletSp = projectile.movementSpeed;
			var m = -Math.sqrt(dx * dx + dy * dy);
			var vx = dx * bulletSp / m;
			var vy = dy * bulletSp / m;
			var pVelVec = new NPoint(vx, vy);
			// accuracy isn't perfect
			pVelVec.rotate(new NPoint(0, 0), Math.random() * NAngle.asDegrees(Math.random() * cannonMissRange * 2 - cannonMissRange));
			vx = pVelVec.x;
			vy = pVelVec.y;
			shootProjectile(projectile, vx, vy);
		}
		if (attackCount % 7 == 0) {
			var projectile:Projectile = null;
			var hydraRng:Bool = Std.int(Math.random() * 7) == 4;
			projectile = new Torpedo(x + width / 2, y + height / 2, target, hydraRng);
			var bulletSp = projectile.movementSpeed;
			var m = -Math.sqrt(dx * dx + dy * dy);
			var vx = dx * bulletSp / m;
			var vy = dy * bulletSp / m;
			var pVelVec = new NPoint(vx, vy);
			// accuracy isn't perfect
			pVelVec.rotate(new NPoint(0, 0), Math.random() * NAngle.asDegrees(Math.random() * torpedoMissRange * 2 - torpedoMissRange));
			vx = pVelVec.x;
			vy = pVelVec.y;
			shootProjectile(projectile, vx, vy);
		}
	}

	private function shootProjectile(pj:Projectile, vx:Float, vy:Float) {
		pj.velocity.set(vx, vy);
		Registry.PS.projectiles.add(pj);
		var recoil = pj.momentum.scale(1 / mass).negate();
		velocity.addPoint(recoil);
		if (x > NGame.width) x = x % NGame.width;
		if (y > NGame.height) y = y % NGame.height;
		if (x < 0) x += NGame.width;
		if (y < 0) y += NGame.height;
		// smoke
		for (i in 0...14) {
			Registry.PS.smokeEffectEmitter.emitSquare(x, y, 6,
				NParticleEmitter.velocitySpread(45, vx / 4, vy / 4),
				NColorUtil.randCol(0.5, 0.5, 0.5), 0.8);
		}
	}

	private function movement() {
		var left = false;
		var up = false;
		var right = false;
		var down = false;

		var target = acquireTarget();
		aiState.friends = Registry.PS.warships;
		aiState.enemies = Registry.PS.allies;
		aiController.target = target;

		var step = aiController.step();
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
}