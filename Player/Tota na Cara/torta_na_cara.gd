extends CharacterBody2D

@export var velocidade_torta:float = 600

func inicializar(direcao_movimento, rotacao):
	rotation = rotacao
	velocity = direcao_movimento * velocidade_torta


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide()


func _on_timer_vida_ataque_timeout():
	queue_free()
