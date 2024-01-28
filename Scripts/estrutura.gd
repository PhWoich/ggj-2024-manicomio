extends StaticBody2D
class_name Estrutura

signal estrutura_destruida(energia)

@export var energia:float = 0
@export var custo_base:int = 15
@export var vida_maxima:int = 100
var vida_atual:int = vida_maxima

@onready var popup_dano = preload("res://Particulas/Popup Dano/popup_dano.tscn")
@onready var ponto_popup = $"Ponto Popup Dano"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	if(energia > 0):
		$"Particula Eletricidade".emitir_particula(energia)

func _on_body_entered(body):
	if body.has_method("permitir_colocar_estrutura"):
		body.permitir_colocar_estrutura(false)

func _on_body_exited(body):
	if body.has_method("permitir_colocar_estrutura"):
		body.permitir_colocar_estrutura(true)

func atualizar_vida(value):
	vida_atual = max(min(vida_maxima, vida_atual + value), 0)
	
	var instancia_popup = popup_dano.instantiate()
	instancia_popup.inicializar(value)
	ponto_popup.add_child(instancia_popup)
	
	if vida_atual == 0:
		emit_signal("estrutura_destruida", -energia)
		if isNucleo():
			get_tree().change_scene_to_file("res://Menus/game_over_screen.tscn")	
		else:
			queue_free()
			
func getType():
	return 'estrutura'

func isNucleo():
	return false

func getTeam():
	return 'player'
