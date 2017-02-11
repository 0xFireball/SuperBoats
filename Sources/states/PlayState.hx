package states;

import n4.NGame;
import n4.NState;
import n4.group.NTypedGroup;
import n4.effects.particles.NParticleEmitter;
import sprites.*;
import sprites.projectiles.*;

class PlayState extends NState implements IEmitterState {
	public var player:PlayerBoat;
	public var warships:NTypedGroup<Warship>;
	public var projectiles:NTypedGroup<Projectile>;
	public var lowerEmitter(default, null):NParticleEmitter;
	public var emitter(default, null):NParticleEmitter;

	override public function create() {
		Registry.PS = this;

		lowerEmitter = new NParticleEmitter(200);
		add(lowerEmitter);

		player = new PlayerBoat(Math.random() * NGame.width, Math.random() * NGame.height);
		player.angle = Math.random() * Math.PI * 2;
		add(player);

		warships = new NTypedGroup<Warship>();
		var enemy = new Warship(Math.random() * NGame.width, Math.random() * NGame.height);
		enemy.angle = Math.random() * Math.PI * 2;
		warships.add(enemy);
		add(warships);

		projectiles = new NTypedGroup<Projectile>();
		add(projectiles);

		emitter = new NParticleEmitter(200);
		add(emitter);

		super.create();
	}

	override public function update(dt:Float) {
		NGame.collide(player, warships);
		NGame.overlap(player, projectiles, playerHitProjectile);

		super.update(dt);
	}

	private function playerHitProjectile(p:PlayerBoat, j:Projectile) {
		j.explode();
	}
}