extends Area2D
class_name Gerador_Basico

@export var energia_gerada:float = 5.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	$"Particula Eletricidade".emitir_particula(energia_gerada)


func _on_body_entered(body):
	if body.has_method("nao_liberar_colocar_gerador"):
		body.nao_liberar_colocar_gerador()


func _on_body_exited(body):
	if body.has_method("liberar_colocar_gerador"):
		body.liberar_colocar_gerador()
