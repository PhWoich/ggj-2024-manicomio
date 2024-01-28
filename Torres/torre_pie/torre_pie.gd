extends Estrutura

@onready var pie = preload("res://Torres/torre_pie/pie.tscn")
@onready var timer = $Timer

var currTargets = []
var curr
var target

func fire():
	if target != null:
		var tempPie = pie.instantiate()
		tempPie.target = target
		tempPie.target_position = target.global_position
		$PieContainer.add_child(tempPie)
		tempPie.global_position = $Aim.global_position

func _ready():
	$AnimatedSprite2D.play("jogar")
	super()

func _on_tower_body_entered(body):
	if(body.has_method('getTeam')):
		if(body.getTeam() == 'louco' && body.has_method('atualizar_vida')):
			currTargets = get_node("torre").get_overlapping_bodies().filter(func(_body): return (_body.has_method('getTeam') && (body.getTeam() == 'louco' && body.has_method('atualizar_vida')) ))

func _on_tower_body_exited(body):
	if(body.has_method('getTeam')):
		if(body.getTeam() == 'louco' && body.has_method('atualizar_vida')):
			currTargets = get_node("torre").get_overlapping_bodies().filter(func(_body): return (_body.has_method('getTeam') && (body.getTeam() == 'louco' && body.has_method('atualizar_vida')) ))

func _on_timer_timeout():
	for i in currTargets:
		if i != null:
			target = i
			fire()
