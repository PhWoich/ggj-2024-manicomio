extends CharacterBody2D

@export var velocidade_torta:float = 600

func inicializar(posicao_inicial:Vector2,direcao_movimento, rotacao):
	position = posicao_inicial
	rotation = rotacao
	velocity = direcao_movimento * velocidade_torta


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	move_and_slide()


func _on_timer_vida_ataque_timeout():
	queue_free()
