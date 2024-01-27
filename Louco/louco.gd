extends CharacterBody2D

var threshold = 1
@export var forca: int = 1
@export var jogador: Node2D
@export var speed: int = 25
@export var vida: int = 1000

func inicializar(jogador_: Node2D):
	jogador = jogador_

func _physics_process(_delta):
	var direcao = (jogador.global_position - global_position)
	var movimento: Vector2
	var x = int(direcao.x)/32
	var y = int(direcao.y)/32

	if abs(x) > abs(y):
		if x > threshold:
			movimento = Vector2.RIGHT
		elif x < -threshold:
			movimento = Vector2.LEFT
	else:
		if y > threshold:
			movimento = Vector2.DOWN
		elif y < -threshold:
			movimento = Vector2.UP

	velocity = movimento * speed
	
	$AnimationTree['parameters/walk/blend_position'] = direcao
	
	move_and_slide()


