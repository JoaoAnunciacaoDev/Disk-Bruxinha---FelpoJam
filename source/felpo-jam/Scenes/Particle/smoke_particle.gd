extends Node2D

@export var smoke_particle : GPUParticles2D

func show_effect(to_show : bool) -> void:
	smoke_particle.emitting = to_show
