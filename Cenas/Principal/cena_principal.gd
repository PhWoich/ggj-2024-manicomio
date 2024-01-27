extends Node2D
class_name Cena_Principal

var energia_maxima:float = 1000.0
var energia_atual_gerada:float = 0.0
var energia_atual_consumida:float = 0.0
var energia_atual_disponivel:float = 0.0

@onready var jogador = preload("res://Player/jogador.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var instancia_jogador = jogador.instantiate()
	instancia_jogador.inicializar_jogador(self)
	add_child(instancia_jogador)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func add_gerador(gerador:PackedScene, posicao:Vector2):
	var instancia_gerador:Gerador_Basico = gerador.instantiate()
	instancia_gerador.position = posicao
	energia_atual_gerada = energia_atual_gerada+instancia_gerador.energia_gerada
	add_child(instancia_gerador)
	print(energia_atual_gerada)
