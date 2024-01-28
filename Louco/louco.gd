extends CharacterBody2D

var threshold = 0
@export var forca: int = 10
@export var cooldown: float = 2
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

var cena: Cena_Principal

func inicializar(jogador_: Node2D, cena_):
	jogador = jogador_
	cena = cena_

func _ready():
	timer.wait_time = cooldown

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
	
	if(shouldWalk):
		move_and_slide()
	
func getType():
	return 'louco'
	
func _onBodyEntered(body: Node2D):
	if(body.has_method('getType')):
		if(body.getType() != 'louco'):
			target = body
			aplicarDano()

func _onBodyExited(_body: Node2D):
	var bodies = $Area2D.get_overlapping_bodies()
	if(!bodies.is_empty()):
		target = bodies[0]
	else:
		target = null
		shouldWalk = true
		
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
