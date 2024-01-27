extends CharacterBody2D
class_name Jogador


@export var velocidade:float = 300.0

func _ready():
	pass

func _physics_process(delta):
	var input_jogador = Vector2(
		Input.get_action_strength("Jogador_direita") - Input.get_action_strength("Jogador_esquerda"),
		Input.get_action_strength("Jogador_baixo") - Input.get_action_strength("Jogador_cima")
	)
	
	velocity = input_jogador * velocidade
	
	move_and_slide()
