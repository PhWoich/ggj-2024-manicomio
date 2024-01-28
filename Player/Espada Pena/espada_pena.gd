extends Area2D
class_name Espada_Pena

var direcao_jogador_olhando
@export var velocidade_rotacao = 0.1
@export var forca: int = 0
# -45° em radianos
var rotacao_inicial:float = -0.785398
var ponto_partida_ataque
var girar_animacao:bool

func inicializar(ponto_partida:Node2D, girar_anim:bool, forca_inicial:int):
	rotacao_inicial = ponto_partida.rotation
	rotation = rotacao_inicial
	girar_animacao= girar_anim
	ponto_partida_ataque = ponto_partida
	forca=forca_inicial

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if girar_animacao:
		rotation = rotation-velocidade_rotacao
		# Quando a tiver rodado 180° em radiano
		if rotation-rotacao_inicial <= -1.5708:
			queue_free()
	else:
		rotation = rotation+velocidade_rotacao
		# Quando a tiver rodado 180° em radiano
		if rotation-rotacao_inicial >= 1.5708:
			queue_free()

func _onBodyEntered(body: Node2D):
	if(body.has_method('getType')):
		if(body.getType() == 'louco' && body.has_method('atualizar_vida')):
			body.atualizar_vida(-forca)
