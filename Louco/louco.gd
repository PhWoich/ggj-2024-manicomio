extends CharacterBody2D

var threshold = 1
var targets = []
@export var forca: int = 1
@export var jogador: Node2D
@export var speed: int = 25
@export var vida: int = 1000
@onready var navegacao := $NavigationAgent2D as NavigationAgent2D

func _ready() -> void:	
	fazer_caminho()

func inicializar(jogador_: Node2D):
	jogador = jogador_

func _physics_process(_delta):
	
	var targetPos = Vector2.ZERO
	var minDist = Vector2.ZERO.distance_to(global_position)
	for target in targets:
		if target:
			var dist = target.global_position.distance_to(global_position)
			if dist < minDist:
				targetPos = target.global_position
				minDist = dist
	
	var direcao = (targetPos - global_position)
	var movimento: Vector2
	var x = int(direcao.x)/32
	var y = int(direcao.y)/32

	print("direccao", direcao)
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
	
	move_and_slide()

func fazer_caminho() -> void:
	navegacao.set_target_position(jogador.global_position)
	

func _on_timer_timeout() -> void:
	fazer_caminho()


func _on_vision_area_2d_body_entered(body):
	if body.has_method("getType") &&  body.getType() == "player":
		targets.append(body)


func _on_vision_area_2d_body_exited(body):
	targets.erase(body)
