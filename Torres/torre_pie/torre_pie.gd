extends Estrutura

@onready var pie = preload("res://Torres/torre_pie/pie.tscn")
@onready var timer = $Timer

var currTargets = []
var curr
var target_position
var target
var tipo_alvo = "Jogador"

func fire():
	if target != null:
		var tempPie = pie.instantiate()
		tempPie.target = target
		tempPie.target_position = target_position
		$PieContainer.add_child(tempPie)
		tempPie.global_position = $Aim.global_position
		tempPie.entrou_louco()
	

func _ready():
	$AnimatedSprite2D.play("jogar")
	custo_base = 25
	energia = -15
	super()


func _on_tower_body_entered(body):
	if tipo_alvo in body.name:
		currTargets = get_node("torre").get_overlapping_bodies()

func _on_tower_body_exited(body):
	if tipo_alvo in body.name:
		currTargets = get_node("torre").get_overlapping_bodies()

func _on_timer_timeout():
	for i in currTargets:
		if i != null:
			if tipo_alvo in i.name:
				target_position = i.global_position
				target = i
				fire()
