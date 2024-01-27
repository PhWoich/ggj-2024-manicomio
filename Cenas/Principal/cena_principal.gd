extends Node2D
class_name Cena_Principal

var energia_maxima:float = 1000.0
var energia_atual_gerada:float = 0.0
var energia_atual_consumida:float = 0.0
var energia_atual_disponivel:float = 0.0

@onready var jogador = preload("res://Player/jogador.tscn")
@onready var gui = $GUI
#Torta na cara que sai do jogador
@onready var torta_na_cara_jogador = preload("res://Player/Tota na Cara/torta_na_cara.tscn")
@onready var camera = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var instancia_jogador = jogador.instantiate()
	instancia_jogador.inicializar_jogador(self, camera)
	instancia_jogador.atirar.connect(gerar_ataque_dist_jogador)
	instancia_jogador.atacar.connect(gui.fire_p1)
	instancia_jogador.atirar.connect(gui.fire_p2)
	add_child(instancia_jogador)
	$AudioStreamPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func add_gerador(gerador:PackedScene, posicao:Vector2):
	var instancia_gerador:Gerador_Basico = gerador.instantiate()
	instancia_gerador.position = posicao
	energia_atual_gerada = energia_atual_gerada+instancia_gerador.energia_gerada
	add_child(instancia_gerador)
	print(energia_atual_gerada)

func gerar_ataque_dist_jogador(posicao, movimento, rotacao, cd):
	var instancia_torta = torta_na_cara_jogador.instantiate()
	instancia_torta.inicializar(posicao,movimento, rotacao)
	add_child(instancia_torta)
