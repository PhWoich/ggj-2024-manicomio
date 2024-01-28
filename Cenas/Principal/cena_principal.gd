extends Node2D
class_name Cena_Principal

var energia_maxima:float = 100.0
var energia_atual_gerada:float = 0.0
var energia_atual_consumida:float = 0.0

var custo_adicional:int
var recurso:int = 1000

@onready var jogador = preload("res://Player/jogador.tscn")
@onready var gui = $GUI
@onready var nucleo = $Nucleo
#Torta na cara que sai do jogador
@onready var torta_na_cara_jogador = preload("res://Player/Tota na Cara/torta_na_cara.tscn")
@onready var camera = $Camera2D

@onready var louco = preload("res://Louco/louco.tscn")
@onready var louco_mickey = preload("res://Louco/louco_mickey.tscn")
@onready var louco_esbugalhada = preload("res://Louco/louco_esbugalhada.tscn")
@onready var cura_power_up = preload("res://PowerUps/PowerUp_cura/power_up_cura.tscn")
@onready var pena_power_up = preload("res://PowerUps/PowerUp_pena/power_up_pena.tscn")
@onready var speed_power_up = preload("res://PowerUps/PowerUp_speed/power_up_speed.tscn")
#Geradores
@onready var g1: PackedScene = preload("res://Geradores/Esteira/gerador_esteira.tscn")
@onready var g2: PackedScene = preload("res://Geradores/Fornalha/gerador_fornalha.tscn")
@onready var g3: PackedScene = preload("res://Geradores/Inalador SA/gerador_inalador_sa.tscn")
var custo_g1: float = 0
var custo_g2: float = 0
var custo_g3: float = 0

#Torres
#TODO
@onready var t1: PackedScene = preload("res://Torres/torre_pie/torre_pie.tscn")
@onready var t2: PackedScene = preload("res://Torres/torre_pena/torre_pena.tscn")
@onready var t3: PackedScene = preload("res://Torres/torre_gas/torre_gas.tscn")
@onready var lista_torres = [t1, t2, t3]
var custo_t1: float = 20
var custo_t2: float = 50
var custo_t3: float = 100

@onready var lista_estruturas = [t1, t2, t3, g1, g2, g3]

#Spawners de inimigos
@onready var spawnerEast: Spawner = $Spawner_east
@onready var spawnerWest: Spawner = $Spawner_west
@onready var spawnerNorth: Spawner = $Spawner_north
@onready var spawnerSouth: Spawner = $Spawner_south

#Spawners de recursos
@onready var spawner_S_power_up: Spawner = $Spawner_S_power_up
@onready var spawner_SW_power_up: Spawner = $Spawner_SW_power_up
@onready var spawner_SE_power_up: Spawner = $Spawner_SE_power_up
@onready var spawner_N_power_up: Spawner = $Spawner_N_power_up
@onready var spawner_NW_power_up: Spawner = $Spawner_NW_power_up
@onready var spawner_NE_power_up: Spawner = $Spawner_NE_power_up
@onready var spawner_W_power_up: Spawner = $Spawner_W_power_up


# Called when the node enters the scene tree for the first time.
func _ready():
	var instancia_jogador = jogador.instantiate()
	instancia_jogador.inicializar_jogador(self, camera)
	instancia_jogador.atirar.connect(gerar_ataque_dist_jogador)
	instancia_jogador.atacar.connect(gui.fire_p1)
	instancia_jogador.atirar.connect(gui.fire_p2)
	instancia_jogador.atualizar_vida_jogador.connect(gui.set_new_health_value)
	instancia_jogador.selecionar_estrutura.connect(gui.set_new_selected_estructure)
	add_child(instancia_jogador)
	$AudioStreamPlayer.play()
	custo_adicional = 0
	
	nucleo.nucleo_danificado.connect(gui.set_central_tower_health)
	
	atualizar_recurso(0)
	atualizar_energia_gerada(0)
	atualizar_energia_consumida(0)
	_getInitialCustos()
	atualizar_custos(0)

	var instancia_louco = louco.instantiate()
	add_child(instancia_louco)
	
	var instancia_louco_mickey = louco_mickey.instantiate()
	add_child(instancia_louco_mickey)
	
	var instancia_louco_esbugalhada = louco_esbugalhada.instantiate()
	add_child(instancia_louco_esbugalhada)
	
	#Spawner de inimigos
	var max_entities_enemies = 50
	spawnerEast.initialize_entityHolder($enemyHolder, max_entities_enemies) #pode ser compartilhado entre todos os spawners
	spawnerEast.add_entity(louco, 3)
	spawnerEast.add_entity(louco_esbugalhada, 2)
	spawnerEast.add_entity(louco_mickey, 1)
	spawnerEast.start()

	spawnerWest.initialize_entityHolder($enemyHolder, max_entities_enemies)
	spawnerWest.add_entity(louco, 3)
	spawnerWest.add_entity(louco_esbugalhada, 2)
	spawnerWest.add_entity(louco_mickey, 1)
	spawnerWest.start()

	spawnerNorth.initialize_entityHolder($enemyHolder, max_entities_enemies)
	spawnerNorth.add_entity(louco, 3)
	spawnerNorth.add_entity(louco_esbugalhada, 2)
	spawnerNorth.add_entity(louco_mickey, 1)
	spawnerNorth.start()

	spawnerSouth.initialize_entityHolder($enemyHolder, max_entities_enemies)
	spawnerSouth.add_entity(louco, 3)
	spawnerSouth.add_entity(louco_esbugalhada, 2)
	spawnerSouth.add_entity(louco_mickey, 1)
	spawnerSouth.start()

	#Spawner de recursos
	var max_entities_power = 7
	spawner_S_power_up.initialize_entityHolder($powerUpHolder, max_entities_power)
	spawner_S_power_up.add_entity(cura_power_up, 1)
	spawner_S_power_up.add_entity(pena_power_up, 1)
	spawner_S_power_up.add_entity(speed_power_up, 1)
	spawner_S_power_up.start()

	spawner_SW_power_up.initialize_entityHolder($powerUpHolder, max_entities_power)
	spawner_SW_power_up.add_entity(cura_power_up, 1)
	spawner_SW_power_up.add_entity(pena_power_up, 1)
	spawner_SW_power_up.add_entity(speed_power_up, 1)
	spawner_SW_power_up.start()

	spawner_SE_power_up.initialize_entityHolder($powerUpHolder, max_entities_power)
	spawner_SE_power_up.add_entity(cura_power_up, 1)
	spawner_SE_power_up.add_entity(pena_power_up, 1)
	spawner_SE_power_up.add_entity(speed_power_up, 1)
	spawner_SE_power_up.start()

	spawner_N_power_up.initialize_entityHolder($powerUpHolder, max_entities_power)
	spawner_N_power_up.add_entity(cura_power_up, 1)
	spawner_N_power_up.add_entity(pena_power_up, 1)
	spawner_N_power_up.add_entity(speed_power_up, 1)
	spawner_N_power_up.start()

	spawner_NW_power_up.initialize_entityHolder($powerUpHolder, max_entities_power)
	spawner_NW_power_up.add_entity(cura_power_up, 1)
	spawner_NW_power_up.add_entity(pena_power_up, 1)
	spawner_NW_power_up.add_entity(speed_power_up, 1)
	spawner_NW_power_up.start()

	spawner_NE_power_up.initialize_entityHolder($powerUpHolder, max_entities_power)
	spawner_NE_power_up.add_entity(cura_power_up, 1)
	spawner_NE_power_up.add_entity(pena_power_up, 1)
	spawner_NE_power_up.add_entity(speed_power_up, 1)
	spawner_NE_power_up.start()

	spawner_W_power_up.initialize_entityHolder($powerUpHolder, max_entities_power)
	spawner_W_power_up.add_entity(cura_power_up, 1)
	spawner_W_power_up.add_entity(pena_power_up, 1)
	spawner_W_power_up.add_entity(speed_power_up, 1)
	spawner_W_power_up.start()
	

func _getInitialCustos():
	custo_g1 = g1.instantiate().custo_base
	custo_g2 = g2.instantiate().custo_base
	custo_g3 = g3.instantiate().custo_base
	
	custo_t1 = t1.instantiate().custo_base
	custo_t2 = t2.instantiate().custo_base
	custo_t3 = t3.instantiate().custo_base

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func add_estrutura(estruturaSelecionada: int, posicao:Vector2):
	var estrutura:Estrutura = lista_estruturas[estruturaSelecionada].instantiate()
	if recurso >= estrutura.custo_base + custo_adicional:
		estrutura.position = posicao
		estrutura.estrutura_destruida.connect(estrutura_destruida_gui)
		if estrutura.energia > 0:
			atualizar_energia_gerada(estrutura.energia)
		else:
			atualizar_energia_consumida(-estrutura.energia)
		atualizar_recurso(-(estrutura.custo_base + custo_adicional))
		atualizar_custos(1)
		add_child(estrutura)
		#estrutura.estrutura_destruida.connect(estrutura_destruida_gui)

func gerar_ataque_dist_jogador(posicao, movimento, rotacao, _cd):
	var instancia_torta = torta_na_cara_jogador.instantiate()
	instancia_torta.inicializar(posicao,movimento, rotacao)
	add_child(instancia_torta)

func atualizar_recurso(quantidade):
	recurso += quantidade
	gui.set_new_resource_value(recurso)
	
func atualizar_energia_gerada(quantidade):
	energia_atual_gerada += quantidade
	if energia_atual_gerada > 100:
		gui.set_max_energy_value(energia_atual_gerada)
		gui.set_used_energy_value(energia_atual_consumida)
	gui.set_available_energy_value(energia_atual_gerada)
	
func atualizar_energia_consumida(quantidade):
	energia_atual_consumida += quantidade
	gui.set_used_energy_value(energia_atual_consumida)
	
func atualizar_custos(quantidade: int):
	custo_adicional += quantidade
	gui.set_towers_cost_values(custo_g1+custo_adicional, custo_t2+custo_adicional, custo_t3+custo_adicional)
	gui.set_generators_cost_values(custo_g1+custo_adicional, custo_g2+custo_adicional, custo_g3+custo_adicional)
	
func atualizar_vida_nucleo(max, value):
	gui.set_central_tower_health(max, value)
func estrutura_destruida_gui(energia):
	if energia > 0:
		atualizar_energia_gerada(-energia)
	else:
		atualizar_energia_consumida(energia)
		
func tem_energia():
	return energia_atual_gerada-energia_atual_consumida > 0
