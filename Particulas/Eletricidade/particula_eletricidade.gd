extends Node2D

# Called when the node enters the scene tree for the first time.
func emitir_particula(quantidade):
	$CPUParticles2D.amount = (quantidade/3)
	$CPUParticles2D.emitting = true
