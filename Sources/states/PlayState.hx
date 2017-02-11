package states;

import n4.NState;
import n4.group.NTypedGroup;
import n4.effects.particles.NParticleEmitter;
import sprites.PlayerBoat;
import sprites.Warship;

class PlayState extends NState implements IEmitterState {
	public var player:PlayerBoat;
	public var warships:NTypedGroup<Warship>;
	public var emitter(default, null):NParticleEmitter;

	override public function create() {
		Registry.PS = this;

		emitter = new NParticleEmitter(200);
		add(emitter);

		player = new PlayerBoat();
		add(player);

		warships = new NTypedGroup<Warship>();
		add(warships);

		super.create();
	}
}