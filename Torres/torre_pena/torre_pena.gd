extends Estrutura

@onready var bolinhas = preload("res://Torres/torre_pena/penas.tscn")
@onready var timer = $Timer

var currLoucos
@export var forca: float = 20

func fire():
	currLoucos = get_node("area_torre_pena").get_overlapping_bodies().filter(func(body): return (body.has_method('getTeam') && (body.getTeam() == 'louco' && body.has_method('atualizar_vida')) ))
	if not(currLoucos.is_empty()):
		var tempBolinhas = bolinhas.instantiate()
		$Bolinhas.add_child(tempBolinhas)
		for louco in currLoucos:
			louco.atualizar_vida(-forca)

func _on_torre_pena_body_entered(body):
	if(body.has_method('getTeam')):
		if(body.getTeam() == 'louco' && body.has_method('atualizar_vida')):
			fire()

func _on_torre_pena_body_exited(_body):
	print('')


func _on_timer_timeout():
	currLoucos = get_node("area_torre_pena").get_overlapping_bodies().filter(func(body): return (body.has_method('getTeam') && (body.getTeam() == 'louco' && body.has_method('atualizar_vida')) ))
	if not(currLoucos.is_empty()):
		fire()
