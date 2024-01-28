extends Area2D


func _on_body_entered(body):
	if body.has_method('add_forca_pena'):
		body.add_forca_pena()
		queue_free()
