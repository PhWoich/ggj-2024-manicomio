extends CharacterBody2D
class_name Jogador

signal atirar_torta(posicao_inicial,movimento,rotacao)

#1. Controles dos movimentos
@export var velocidade:float = 300.0
var input_jogador
var ultimo_movimento:Vector2

#2. Controles dos ataques
@onready var inicio_ataque_cima = $Inicio_ataque_cima
@onready var inicio_ataque_direita = $Inicio_ataque_direita
@onready var inicio_ataque_baixo = $Inicio_ataque_baixo
@onready var inicio_ataque_esquerda = $Inicio_ataque_esquerda
var ultima_direcao_olhada:Node2D
var girar_animacao_ataque:bool
var pode_atacar:bool = true
var ataque_dist_rotacao = 0.0
#  2.1 Carregar espada penas
@onready var espada_pena = preload("res://Player/Espada Pena/espada_pena.tscn")

#3. Controles de Geradores
var cena_jogo
var gerador_basico = preload("res://Geradores/Basico/gerador_basico.tscn")
var pode_colocar_gerador:bool

func _ready():
	jogador_pode_atacar()
	ultima_direcao_olhada = inicio_ataque_direita
	girar_animacao_ataque=false
	pode_colocar_gerador=true

func inicializar_jogador(cena_atual):
	cena_jogo = cena_atual

func _physics_process(_delta):
	#Movimento jogador
	input_jogador = Vector2(
		Input.get_action_strength("Jogador_direita") - Input.get_action_strength("Jogador_esquerda"),
		Input.get_action_strength("Jogador_baixo") - Input.get_action_strength("Jogador_cima")
	)
	var movimento:Vector2
	if input_jogador.x > 0:
		movimento = Vector2(1.0, 0.0)
		ultimo_movimento = movimento
		ultima_direcao_olhada = inicio_ataque_direita
		girar_animacao_ataque=false
		ataque_dist_rotacao = 0.0
	elif input_jogador.x < 0:
		movimento = Vector2(-1.0, 0.0)
		ultimo_movimento = movimento
		ultima_direcao_olhada = inicio_ataque_esquerda
		girar_animacao_ataque=true
		ataque_dist_rotacao = 3.14159
	elif input_jogador.y < 0:
		movimento = Vector2(0.0, -1.0)
		ultimo_movimento = movimento
		ultima_direcao_olhada = inicio_ataque_cima
		girar_animacao_ataque = true
		ataque_dist_rotacao = 4.71239
	elif input_jogador.y > 0:
		movimento = Vector2(0.0, 1.0)
		ultimo_movimento = movimento
		ultima_direcao_olhada = inicio_ataque_baixo
		girar_animacao_ataque = false
		ataque_dist_rotacao = 1.5708
	
	velocity = movimento * velocidade
	
	move_and_slide()
	
	#Ataques
	if Input.is_action_just_released("Jogador_ataque_melee") and pode_atacar:
		ataque_corpo_a_corpo()
	
	
	if Input.is_action_just_released("Jogador_ataque_distancia") and pode_atacar:
		ataque_a_distancia()
	
	#Add Gerador
	if Input.is_action_just_released("jogador_adicionar_gerador") and pode_colocar_gerador:
		add_gerador()

func ataque_corpo_a_corpo():
	var instancia_espada_pena = espada_pena.instantiate()
	instancia_espada_pena.inicializar(ultima_direcao_olhada, girar_animacao_ataque)
	instancia_espada_pena.ataque_encerrado.connect(jogador_pode_atacar)
	pode_atacar = false
		
	ultima_direcao_olhada.add_child(instancia_espada_pena)

func ataque_a_distancia():
	emit_signal("atirar_torta", (position + ultima_direcao_olhada.position), ultimo_movimento, ataque_dist_rotacao)
	pode_atacar = false
	$Timer_ataque_distancia.start()

func jogador_pode_atacar():
	pode_atacar = true


func add_gerador():
	cena_jogo.add_gerador(gerador_basico, position)


func nao_liberar_colocar_gerador():
	pode_colocar_gerador = false


func liberar_colocar_gerador():
	pode_colocar_gerador = true


func _on_timer_ataque_distancia_timeout():
	jogador_pode_atacar()
