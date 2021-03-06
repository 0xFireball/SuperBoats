package states;

import kha.Color;

import n4.NGame;
import n4.NG;
import n4.NState;
import n4.group.NTypedGroup;
import n4.effects.particles.NParticleEmitter;
import n4.util.NColorUtil;

import n4e.ui.NEText;

import sprites.*;
import sprites.projectiles.*;

class PlayState extends NState implements IEmitterState {
	public var player:PlayerBoat;
	public var allies:NTypedGroup<GreenBoat>;
	public var warships:NTypedGroup<Warship>;
	public var mothership:Mothership; // the main enemy
	public var projectiles:NTypedGroup<Projectile>;
	public var playerProjectiles:NTypedGroup<Projectile>;
	public var lowerEmitter(default, null):NParticleEmitter;
	public var emitter(default, null):NParticleEmitter;
	public var explosionEmitter(default, null):NParticleEmitter;
	public var smokeEffectEmitter(default, null):NParticleEmitter;
	public var helpText(default, null):NEText;

	override public function create() {
		Registry.PS = this;

		bgColor = Color.fromValue(0xFF073F52);

		lowerEmitter = new NParticleEmitter(115);
		add(lowerEmitter);

		allies = new NTypedGroup<GreenBoat>();
		player = new PlayerBoat(Math.random() * NGame.width, Math.random() * NGame.height);
		player.angle = Math.random() * Math.PI * 2;
		allies.add(player);
		add(allies);

		warships = new NTypedGroup<Warship>();
		mothership = new Mothership(Math.random() * NGame.width, Math.random() * NGame.height);
		mothership.angle = Math.random() * Math.PI * 2;
		warships.add(mothership);
		add(warships);

		projectiles = new NTypedGroup<Projectile>(24);
		add(projectiles);

		playerProjectiles = new NTypedGroup<Projectile>(18);
		add(playerProjectiles);

		emitter = new NParticleEmitter(70);
		add(emitter);

		explosionEmitter = new NParticleEmitter(120);
		add(explosionEmitter);

		smokeEffectEmitter = new NParticleEmitter(140);
		add(smokeEffectEmitter);

		helpText = new NEText(0, NGame.height / 3, "", 40);
		add(helpText);

		super.create();
	}

	override public function update(dt:Float) {
		// NGame.collide(player, warships);
		NG.overlap(allies, projectiles, allyHitProjectile);
		NG.overlap(warships, playerProjectiles, warshipHitProjectile);

		if (NG.keys.justPressed(["ESC"])) {
			// reopen menu
			NGame.switchState(Registry.MS);
		}

		super.update(dt);

		// check game status
		checkGameStatus();
	}

	private function checkGameStatus() {
		// update final vars
		Registry.lastMsDamage = mothership.damage;

		if (!player.exists) {
			// RIP, the player died
			NGame.timers.setTimer(500, function() {
				Registry.PS = null; // can't resume
				NGame.switchState(new GameOverState());
			});
		}
		if (!mothership.exists) {
			// wow, good job!
			NGame.timers.setTimer(500, function() {
				Registry.PS = null; // can't resume
				NGame.switchState(new YouWonState());
			});
		}
	}

	private function allyHitProjectile(p:GreenBoat, j:Projectile) {
		j.hitSprite(p);
	}

	private function warshipHitProjectile(w:Warship, j:Projectile) {
		j.hitSprite(w);
	}
}