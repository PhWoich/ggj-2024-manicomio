extends Area2D

var target 
var Speed = 3
var target_position
var direcao_movimento 

var tipo_alvo = "Jogador"

@export var forca: float = 20

func _physics_process(_delta):
	if target != null:
		look_at(target.global_position)
		direcao_movimento = global_position.direction_to(target.global_position).normalized() * Speed
		global_position = global_position + direcao_movimento

func _on_area_2d_body_entered(body):
	if(body.has_method('getTeam')):
		if(body.getTeam() == 'louco' && body.has_method('atualizar_vida')):
			body.atualizar_vida(-forca)
			queue_free()

func _on_timer_timeout():
	queue_free()
