extends Node2D
class_name Cena_Principal

var energia_maxima:float = 1000.0
var energia_atual_gerada:float = 0.0
var energia_atual_consumida:float = 0.0

var custo_adicional:int
var recurso:int = 100

@onready var jogador = preload("res://Player/jogador.tscn")
#Torta na cara que sai do jogador
@onready var torta_na_cara_jogador = preload("res://Player/Tota na Cara/torta_na_cara.tscn")
@onready var camera = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var instancia_jogador = jogador.instantiate()
	instancia_jogador.inicializar_jogador(self, camera)
	instancia_jogador.atirar_torta.connect(gerar_ataque_dist_jogador)
	add_child(instancia_jogador)
	$AudioStreamPlayer.play()
	custo_adicional = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func add_gerador(gerador:PackedScene, posicao:Vector2):
	var instancia_gerador:Gerador_Basico = gerador.instantiate()
	if recurso >= instancia_gerador.custo_base + custo_adicional:
		instancia_gerador.position = posicao
		instancia_gerador.gerador_destruido.connect(reduzir_energia_gerada)
		energia_atual_gerada = energia_atual_gerada+instancia_gerador.energia_gerada
		recurso = recurso-(instancia_gerador.custo_base + custo_adicional)
		custo_adicional = custo_adicional+1
		add_child(instancia_gerador)

func gerar_ataque_dist_jogador(posicao, movimento, rotacao):
	var instancia_torta = torta_na_cara_jogador.instantiate()
	instancia_torta.inicializar(posicao,movimento, rotacao)
	add_child(instancia_torta)

func reduzir_energia_gerada(quantidade):
	energia_atual_gerada = energia_atual_gerada-quantidade
	print(energia_atual_gerada)
