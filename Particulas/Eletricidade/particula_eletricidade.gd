extends Node2D


@onready var particulas = $CPUParticles2D

# Called when the node enters the scene tree for the first time.
func emitir_particula(quantidade):
	$CPUParticles2D.amount = quantidade
	$CPUParticles2D.emitting = true
