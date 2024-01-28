extends Area2D


func _on_body_entered(body):
	if body.has_method('curar_vida_jogador'):
		body.curar_vida_jogador()
		queue_free()
