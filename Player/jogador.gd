extends CharacterBody2D
class_name Jogador

#1. Controles dos movimentos
@export var velocidade:float = 300.0
@export var starting_direction : Vector2 = Vector2(0, 1)
var input_jogador
var ultimo_movimento:Vector2

#2. Controles dos ataques
@export var cooldown_ataque: float = 0.5
@export var cooldown_atirar: float = 2
signal atacar(posicao_inicial, movimento, rotacao, cooldown_ataque)
signal atirar(posicao_inicial, movimento, rotacao, cooldown_atirar)

var pode_atacar:bool = true
var pode_atirar:bool = true
@onready var timerAtacar = $Timer_atacar
@onready var timerAtirar = $Timer_atirar

@onready var inicio_ataque_cima = $Inicio_ataque_cima
@onready var inicio_ataque_direita = $Inicio_ataque_direita
@onready var inicio_ataque_baixo = $Inicio_ataque_baixo
@onready var inicio_ataque_esquerda = $Inicio_ataque_esquerda
var ultima_direcao_olhada:Node2D
var girar_animacao_ataque:bool
var ataque_dist_rotacao = 0.0

#  2.1 Carregar espada penas
@onready var espada_pena = preload("res://Player/Espada Pena/espada_pena.tscn")
var forca_pena:int = 15

#3. Controles de Geradores
var cena_jogo
#var gerador_basico = preload("res://Geradores/Basico/gerador_basico.tscn")
signal selecionar_estrutura(value: int)
var estrutura_selecionada: int = 0
var pode_colocar_estrutura:bool

#4. Controle de animacoes
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

#5. Vida do jogador
@export var vida_maxima: float = 100
var vida_atual: float = 100
signal atualizar_vida_jogador(vida_atual: float, vida_maxima: float);

func _ready():
	timerAtacar.wait_time = cooldown_ataque
	timerAtirar.wait_time = cooldown_atirar
	jogador_pode_atacar()
	jogador_pode_atirar()
	ultima_direcao_olhada = inicio_ataque_direita
	girar_animacao_ataque= false
	pode_colocar_estrutura= true
	
	update_animation_parameter(starting_direction)
	atualizar_vida(0)

func inicializar_jogador(cena_atual, camera):
	cena_jogo = cena_atual
	$RemoteTransform2D.remote_path = camera.get_path()

func _physics_process(_delta):
	#Movimento jogador
	input_jogador = Vector2(
		Input.get_action_strength("Jogador_direita") - Input.get_action_strength("Jogador_esquerda"),
		Input.get_action_strength("Jogador_baixo") - Input.get_action_strength("Jogador_cima")
	)
	var movimento:Vector2
	
	update_animation_parameter(input_jogador)
	
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
	pick_new_state()
	
	#Ataques
	if Input.is_action_just_released("Jogador_ataque_melee") and pode_atacar:
		ataque_corpo_a_corpo()
		
	if Input.is_action_just_released("Jogador_ataque_distancia") and pode_atirar:
		ataque_a_distancia()
	#Add Gerador
	if Input.is_action_just_released("selecionar_prox_gerador"):
		selecionar_prox_estrutura()
	
	if Input.is_action_just_released("selecionar_gerador_anterior"):
		selecionar_estrutura_anterior()
	
	if Input.is_action_just_released("jogador_adicionar_gerador") and pode_colocar_estrutura:
		add_estrutura()
	
	if Input.is_action_just_released("Delete_estrutura"):
		delete_estrutura()

func ataque_corpo_a_corpo():
	emit_signal("atacar", (position + ultima_direcao_olhada.position), ultimo_movimento, ataque_dist_rotacao, cooldown_ataque)
	var instancia_espada_pena = espada_pena.instantiate()
	instancia_espada_pena.inicializar(ultima_direcao_olhada, girar_animacao_ataque, forca_pena)
	ultima_direcao_olhada.add_child(instancia_espada_pena)
	
	pode_atacar = false
	timerAtacar.start()	

func ataque_a_distancia():
	emit_signal("atirar", (position + ultima_direcao_olhada.position), ultimo_movimento, ataque_dist_rotacao, cooldown_atirar)
	pode_atirar = false
	timerAtirar.start()

func jogador_pode_atacar():
	pode_atacar = true
	
func jogador_pode_atirar():
	pode_atirar = true

func delete_estrutura():
	match ultima_direcao_olhada:
		inicio_ataque_baixo:
			var body = $ShapeCast2D_down.get_collider(0)
			if body and body.has_method("getType") and body.getType() == "estrutura":
				body.queue_free()
		inicio_ataque_cima:
			var body = $ShapeCast2D_up.get_collider(0)
			if body and body.has_method("getType") and body.getType() == "estrutura":
				body.queue_free()
		inicio_ataque_direita:
			var body = $ShapeCast2D_right.get_collider(0)
			if body and body.has_method("getType") and body.getType() == "estrutura":
				body.queue_free()
		inicio_ataque_esquerda:
			var body = $ShapeCast2D_left.get_collider(0)
			if body and body.has_method("getType") and body.getType() == "estrutura":
				body.queue_free()

func selecionar_prox_estrutura():
	estrutura_selecionada = estrutura_selecionada+1
	
	if estrutura_selecionada == 6:
		estrutura_selecionada = 0
		
	emit_signal("selecionar_estrutura", estrutura_selecionada)

func selecionar_estrutura_anterior():
	estrutura_selecionada = estrutura_selecionada-1
	
	if estrutura_selecionada < 0:
		estrutura_selecionada = 5
		
	emit_signal("selecionar_estrutura", estrutura_selecionada)

func add_estrutura():
	cena_jogo.add_estrutura(estrutura_selecionada, position)

func permitir_colocar_estrutura(value: bool):
	pode_colocar_estrutura = value

func _on_timer_ataque_distancia_timeout():
	jogador_pode_atacar()

func update_animation_parameter(move_input: Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree['parameters/walk/blend_position'] = move_input
		animation_tree['parameters/idle/blend_position'] = move_input
		
func pick_new_state():	
	if(velocity != Vector2.ZERO):		
		animation_tree['parameters/conditions/idle'] = false
		animation_tree['parameters/conditions/is_moving'] = true
	else:
		animation_tree['parameters/conditions/idle'] = true
		animation_tree['parameters/conditions/is_moving'] = false
		
func atualizar_vida(value: float):
	vida_atual = max(min(vida_maxima, vida_atual + value), 0)
	emit_signal('atualizar_vida_jogador', vida_atual, vida_maxima)

func getTeam():
	return 'player'
	

func curar_vida_jogador():
	vida_atual = vida_maxima
	emit_signal('atualizar_vida_jogador', vida_atual, vida_maxima)
	var penas = preload("res://Particulas/Coracao/explosao_coracao.tscn")
	var instance_penas = penas.instantiate()
	$Ponto_partida_particulas.add_child(instance_penas)
	instance_penas.emitir_particula()

func add_forca_pena():
	forca_pena = forca_pena+5
	var penas = preload("res://Particulas/Explosão Penas/explosao_penas.tscn")
	var instance_penas = penas.instantiate()
	$Ponto_partida_particulas.add_child(instance_penas)
	instance_penas.emitir_particula()

func add_velocidade_jogador():
	velocidade = velocidade+25
	var penas = preload("res://Particulas/UpSpeed/UpSpeed.tscn")
	var instance_penas = penas.instantiate()
	$Ponto_partida_particulas.add_child(instance_penas)
	instance_penas.emitir_particula()
