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
		angularThrust = 0.03 * Math.PI;
		thrust = 0.5;
		wrapBounds = false;
		mass = 84000;
		sprayAmount = 20;
		spraySpread = 80;
		makeGraphic(30, 65, Color.Red);
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
			projectile = new Cannonball(x + width / 2, y + height / 2);
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
			projectile = new Torpedo(x + width / 2, y + height / 2);
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
		var recoilSpeed = pj.momentum / mass;
		var recoilMotion = new NVector(pj.velocity.x, pj.velocity.y);
		var recoilVelocity = recoilMotion.normalize().scale(-recoilSpeed);
		velocity.x += recoilVelocity.x;
		velocity.y += recoilVelocity.y;
		if (x > NGame.width) x = x % NGame.width;
		if (y > NGame.height) y = y % NGame.height;
		if (x < 0) x += NGame.width;
		if (y < 0) y += NGame.height;
		for (i in 0...14) {
			Registry.currentEmitterState.emitter.emitSquare(x, y, 6,
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

		// process AI logic
		if (x < NGame.width / 4 || x > NGame.width * (3 / 4) || y < NGame.height / 4 || y > NGame.height * (3 / 4)) {
			// if going near the edge, point to the center
			var fieldCenter = new NVector(NGame.width / 2, NGame.height / 2);
			var distToCenter = new NVector(x, y).subtractNew(fieldCenter);
			// create an angle from the current position to the center
			var angleToCenter = NAngle.asRadians(new NVector(x, y).angleBetween(fieldCenter));
			if (Math.abs(facingAngle - angleToCenter) > Math.PI / 8) {
				if (facingAngle < angleToCenter) {
					right = true;
				} else if (facingAngle > angleToCenter) {
					left = true;
				}
			}
			var fieldHypot = Math.sqrt(NGame.width * NGame.width + NGame.height * NGame.height);
			if (distToCenter.length > fieldHypot / 4) {
				up = true;
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