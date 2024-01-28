extends Node2D
class_name Cena_Principal

var energia_maxima:float = 100.0
var energia_atual_gerada:float = 0.0
var energia_atual_consumida:float = 0.0

var custo_adicional:int
var recurso:int = 1000

@onready var jogador = preload("res://Player/jogador.tscn")
@onready var gui = $GUI
#Torta na cara que sai do jogador
@onready var torta_na_cara_jogador = preload("res://Player/Tota na Cara/torta_na_cara.tscn")
@onready var camera = $Camera2D

@onready var louco = preload("res://Louco/louco.tscn")
@onready var louco_mickey = preload("res://Louco/louco_mickey.tscn")
@onready var louco_esbugalhada = preload("res://Louco/louco_esbugalhada.tscn")
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


#Spawners
@onready var spawnerEast: Spawner = $Spawner_east
@onready var spawnerWest: Spawner = $Spawner_west
@onready var spawnerNorth: Spawner = $Spawner_north
@onready var spawnerSouth: Spawner = $Spawner_south

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
	
	atualizar_recurso(0)
	atualizar_energia_gerada(0)
	atualizar_energia_consumida(0)
	_getInitialCustos()
	atualizar_custos(0)

	var instancia_louco = louco.instantiate()
	instancia_louco.inicializar(instancia_jogador, self)
	add_child(instancia_louco)
	
	var instancia_louco_mickey = louco_mickey.instantiate()
	instancia_louco_mickey.inicializar(instancia_jogador, self)
	add_child(instancia_louco_mickey)
	
	var instancia_louco_esbugalhada = louco_esbugalhada.instantiate()
	instancia_louco_esbugalhada.inicializar(instancia_jogador, self)
	add_child(instancia_louco_esbugalhada)
	
	#Spawner
	spawnerEast.initialize_entityHolder($enemyHolder) #pode ser compartilhado entre todos os spawners
	spawnerEast.add_entity(louco, 3)
	spawnerEast.add_entity(louco_esbugalhada, 2)
	spawnerEast.add_entity(louco_mickey, 1)
	spawnerEast.start()

	spawnerWest.initialize_entityHolder($enemyHolder)
	spawnerWest.add_entity(louco, 3)
	spawnerWest.add_entity(louco_esbugalhada, 2)
	spawnerWest.add_entity(louco_mickey, 1)
	spawnerWest.start()

	spawnerNorth.initialize_entityHolder($enemyHolder)
	spawnerNorth.add_entity(louco, 3)
	spawnerNorth.add_entity(louco_esbugalhada, 2)
	spawnerNorth.add_entity(louco_mickey, 1)
	spawnerNorth.start()

	spawnerSouth.initialize_entityHolder($enemyHolder)
	spawnerSouth.add_entity(louco, 3)
	spawnerSouth.add_entity(louco_esbugalhada, 2)
	spawnerSouth.add_entity(louco_mickey, 1)
	spawnerSouth.start()
	

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
		estrutura.estrutura_destruida.connect(atualizar_energia_gerada)
		atualizar_energia_gerada(estrutura.energia)
		atualizar_recurso(-(estrutura.custo_base + custo_adicional))
		atualizar_custos(1)
		add_child(estrutura)

func gerar_ataque_dist_jogador(posicao, movimento, rotacao, _cd):
	var instancia_torta = torta_na_cara_jogador.instantiate()
	instancia_torta.inicializar(posicao,movimento, rotacao)
	add_child(instancia_torta)

func atualizar_recurso(quantidade):
	recurso += quantidade
	gui.set_new_resource_value(recurso)
	
func atualizar_energia_gerada(quantidade):
	energia_atual_gerada += quantidade
	gui.set_available_energy_value(energia_atual_gerada)
	
func atualizar_energia_consumida(quantidade):
	energia_atual_consumida += quantidade
	gui.set_used_energy_value(energia_atual_consumida)
	
func atualizar_custos(quantidade: int):
	custo_adicional += quantidade
	gui.set_towers_cost_values(custo_g1+custo_adicional, custo_t2+custo_adicional, custo_t3+custo_adicional)
	gui.set_generators_cost_values(custo_g1+custo_adicional, custo_g2+custo_adicional, custo_g3+custo_adicional)
	
