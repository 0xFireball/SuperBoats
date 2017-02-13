package sprites;

import kha.Color;

import n4.math.NPoint;
import n4.math.NVector;
import n4.math.NAngle;
import n4.NGame;
import n4.effects.particles.NParticleEmitter;
import n4.util.NColorUtil;

import sprites.projectiles.*;

class Warship extends Boat {
	private static var attackTime:Float = 0.2;
	private var attackTimer:Float = 0;
	private var attackCount:Int = 0;
	private var cannonMissRange:Float = Math.PI * 1 / 8;
	private var torpedoMissRange:Float = Math.PI * 1 / 3;

	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);
		thrust = 0.6;
		wrapBounds = false;
		mass = 184000;
		sprayAmount = 20;
		spraySpread = 80;
		angularThrust = 0.027 * Math.PI;
		maxAngular = Math.PI / 5;
		maxVelocity.set(60, 60);
		renderGraphic(30, 65, function (gpx) {
			var ctx = gpx.g2;
			ctx.begin();
			ctx.color = Color.fromFloats(0.9, 0.3, 0.1);
			ctx.fillRect(0, 0, width, height);
			ctx.color = Color.fromFloats(0.9, 0.5, 0.1);
			ctx.fillRect(width / 3, height * (3 / 4), width / 3, height / 4);
			ctx.end();
		}, "warship");
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

	private function attackPlayer() {
		if (attackCount % 3 == 0) {
			var projectile:Projectile = null;
			projectile = new Cannonball(x + width / 2, y + height / 2, Registry.PS.player);
			var bulletSp = projectile.movementSpeed;
			var player = Registry.PS.player;
			var dx = (x + width / 2) - (player.x + player.width / 2);
			var dy = (y + height / 2) - (player.y + player.height / 2);
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
			projectile = new Torpedo(x + width / 2, y + height / 2, Registry.PS.player, hydraRng);
			var bulletSp = projectile.movementSpeed;
			var player = Registry.PS.player;
			var dx = (x + width / 2) - (player.x + player.width / 2);
			var dy = (y + height / 2) - (player.y + player.height / 2);
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


		// forward is in the direction the boat is pointing
		var facingAngle = angle; // facing upward
		var selfPosition = new NVector(x, y);

		// process AI logic
		// if going near the edge, point to the center
		var targetSetpoint:NVector = null;
		var playerPosition = new NVector(Registry.PS.player.x, Registry.PS.player.y);
		// targetSetpoint = new NVector(NGame.width / 2, NGame.height / 2);
		var fieldHypot = Math.sqrt(NGame.width * NGame.width + NGame.height * NGame.height);
		if (selfPosition.distanceTo(playerPosition) > fieldHypot / 3) {
			targetSetpoint = playerPosition;
		} else if (x < NGame.width / 4 || x > NGame.width * (3 / 4)
			|| y < NGame.height / 4 || y > NGame.height * (3 / 4)) {
			targetSetpoint = new NVector(NGame.width / 2, NGame.height / 2);
		}

		if (targetSetpoint != null) {
			var distToTarget = new NVector(x, y).subtractNew(targetSetpoint);
			// create an angle from the current position to the center
			var angleToSetpoint = NAngle.asRadians(new NVector(x, y).angleBetween(targetSetpoint));
			if (Math.abs(facingAngle - angleToSetpoint) > Math.PI / 8) {
				if (facingAngle < angleToSetpoint) {
					right = true;
				} else if (facingAngle > angleToSetpoint) {
					left = true;
				}
			} else {
				// we're on target
				if (distToTarget.length > fieldHypot / 4) {
					up = true;
				}
			}
		}

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
		thrustVector.rotate(new NPoint(0, 0), NAngle.asDegrees(facingAngle));
		velocity.addPoint(thrustVector);
	}
}