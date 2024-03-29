extends CharacterBody2D

var threshold = 0
@export var forca: int = 10
@export var cooldown: float = 2
var targets = []
@export var jogador: Node2D
@export var speed: int = 25
@export var recursoRecompensa: int = 5

var shouldWalk: bool = true
var target: Node2D
@onready var timer: Timer = $Timer_atacar

#5. Vida do Louco
@export var vida_maxima: float = 100
var vida_atual: float = vida_maxima
signal atualizar_vida_jogador(vida_atual: float, vida_maxima: float);

@onready var cena = find_parent('CenaPrincipal')
	
func _ready():
	timer.wait_time = cooldown

func _physics_process(_delta):
	
	var targetPos = Vector2.ZERO
	var minDist = Vector2.ZERO.distance_to(global_position)
	for target_ in targets:
		if target_:
			var dist = target_.global_position.distance_to(global_position)
			if dist < minDist:
				targetPos = target_.global_position
				minDist = dist
	
	var direcao = (targetPos - global_position)
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
	
	#if(shouldWalk):
	move_and_slide()
	
func getTeam():
	return 'louco'
	
func _onBodyEntered(body: Node2D):
	if(body.has_method('getTeam')):
		if(body.getTeam() != 'louco'):
			target = body
			aplicarDano()

func _onBodyExited(_body: Node2D):
	var bodies = $HitboxArea2D.get_overlapping_bodies()

	target = null
	shouldWalk = true
	if(!bodies.is_empty()):
		for body in bodies:
			if(body.has_method("getTeam") and body.getTeam() != 'louco'):
				shouldWalk = false
				target = body
				break
		
func aplicarDano():
	if(target != null && target.has_method('atualizar_vida')):
		target.atualizar_vida(-forca)
		timer.start()
		shouldWalk = false
	
func _onTimerAtacarTimeout():
	aplicarDano()
	
func atualizar_vida(value: float):
	vida_atual = max(min(vida_maxima, vida_atual + value), 0)
	if(vida_atual == 0):
		cena.atualizar_recurso(recursoRecompensa)
		queue_free()

func _on_vision_area_2d_body_entered(body):
	if body.has_method("getTeam") &&  body.getTeam() == "player":
		targets.append(body)

func _on_vision_area_2d_body_exited(body):
	targets.erase(body)
