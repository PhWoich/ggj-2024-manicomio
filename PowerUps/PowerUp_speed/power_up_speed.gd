extends Area2D


func _on_body_entered(body):
	if body.has_method('add_velocidade_jogador'):
		body.add_velocidade_jogador()
		queue_free()
