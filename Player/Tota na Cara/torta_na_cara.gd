extends Area2D

@export var velocidade_torta:float = 10
@export var forca: float = 20
var movimento_torta

func inicializar(posicao_inicial:Vector2,direcao_movimento, rotacao):
	position = posicao_inicial
	rotation = rotacao
	movimento_torta = direcao_movimento * velocidade_torta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position = position+movimento_torta

func _on_timer_vida_ataque_timeout():
	queue_free()

func _onBodyEntered(body: Node2D):
	if(body.has_method('getTeam')):
		if(body.getTeam() == 'louco' && body.has_method('atualizar_vida')):
			body.atualizar_vida(-forca)
			queue_free()
