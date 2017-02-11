package states;

import n4.effects.particles.NParticleEmitter;

interface IEmitterState {
	public var emitter(default, null):NParticleEmitter;
}