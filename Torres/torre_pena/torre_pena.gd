extends StaticBody2D

@onready var bolinhas = preload("res://Torre/torre_pena/penas.tscn")
@onready var timer = $Timer

var currTargets = []

var tipo_alvo = "Jogador"

func fire():
	if not(currTargets.is_empty()):
		var tempBolinhas = bolinhas.instantiate()
		$Bolinhas.add_child(tempBolinhas)

func _ready():
	pass

func _on_torre_pena_body_entered(body):
	if tipo_alvo in body.name:
		currTargets = get_node("area_torre_pena").get_overlapping_bodies()
		fire()
	pass 


func _on_torre_pena_body_exited(body):
	if tipo_alvo in body.name:
		currTargets = get_node("area_torre_pena").get_overlapping_bodies()
	pass 


func _on_timer_timeout():
	for i in currTargets:
		if i != null:
			if tipo_alvo in i.name:
				fire()
