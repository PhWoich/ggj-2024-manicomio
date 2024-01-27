extends CharacterBody2D
class_name Jogador

#1. Controles dos movimentos
@export var velocidade:float = 300.0
var input_jogador

#2. Controles dos ataques
@onready var inicio_ataque_cima = $Inicio_ataque_cima
@onready var inicio_ataque_direita = $Inicio_ataque_direita
@onready var inicio_ataque_baixo = $Inicio_ataque_baixo
@onready var inicio_ataque_esquerda = $Inicio_ataque_esquerda
var ultima_direcao_olhada
var girar_animacao_ataque:bool
var pode_atacar:bool = true
#  2.1 Carregar espada penas
var espada_pena = preload("res://Player/Espada Pena/espada_pena.tscn")

func _ready():
	jogador_pode_atacar()
	ultima_direcao_olhada = inicio_ataque_direita
	girar_animacao_ataque=false

func _physics_process(delta):
	#Movimento jogador
	input_jogador = Vector2(
		Input.get_action_strength("Jogador_direita") - Input.get_action_strength("Jogador_esquerda"),
		Input.get_action_strength("Jogador_baixo") - Input.get_action_strength("Jogador_cima")
	)
	if input_jogador.x > 0:
		ultima_direcao_olhada = inicio_ataque_direita
		girar_animacao_ataque=false
	elif input_jogador.x < 0:
		ultima_direcao_olhada = inicio_ataque_esquerda
		girar_animacao_ataque=true
	elif input_jogador.y < 0:
		ultima_direcao_olhada = inicio_ataque_cima
		girar_animacao_ataque = true
	elif input_jogador.y > 0:
		ultima_direcao_olhada = inicio_ataque_baixo
		girar_animacao_ataque = false
	
	velocity = input_jogador * velocidade
	
	move_and_slide()
	
	#Ataque corpo-a-corpo
	if Input.is_action_just_released("Jogador_ataque") and pode_atacar:
		ataque_corpo_a_corpo()

func ataque_corpo_a_corpo():
	var instancia_espada_pena = espada_pena.instantiate()
	instancia_espada_pena.inicializar(ultima_direcao_olhada, girar_animacao_ataque)
	instancia_espada_pena.ataque_encerrado.connect(jogador_pode_atacar)
	pode_atacar = false
		
	ultima_direcao_olhada.add_child(instancia_espada_pena)

func jogador_pode_atacar():
	pode_atacar = true
