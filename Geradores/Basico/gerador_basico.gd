extends Area2D
class_name Gerador_Basico

signal gerador_destruido(energia_gerador)

@export var energia_gerada:float = 5.0
@export var custo_base:int = 15
@export var vida_gerador:int = 100

@onready var popup_dano = preload("res://Particulas/Popup Dano/popup_dano.tscn")
@onready var ponto_popup = $"Ponto Popup Dano"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	$"Particula Eletricidade".emitir_particula(energia_gerada)


func _physics_process(_delta):
	atualizar_vida(-1)

func _on_body_entered(body):
	if body.has_method("nao_liberar_colocar_gerador"):
		body.nao_liberar_colocar_gerador()


func _on_body_exited(body):
	if body.has_method("liberar_colocar_gerador"):
		body.liberar_colocar_gerador()

func atualizar_vida(valor_atualizacao):
	vida_gerador = vida_gerador+valor_atualizacao
	
	var instancia_popup = popup_dano.instantiate()
	instancia_popup.inicializar(valor_atualizacao)
	ponto_popup.add_child(instancia_popup)
	
	if vida_gerador <= 0:
		emit_signal("gerador_destruido", -energia_gerada)
		queue_free()
