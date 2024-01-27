extends Area2D

@export var velocidade_torta:float = 10
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
