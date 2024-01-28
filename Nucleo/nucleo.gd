extends Estrutura

signal nucleo_danificado(vida_atual, vida_maxima)

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	atualizar_vida(0)
	
func isNucleo():
	return true

func getTeam():
	return "player"
	
func atualizar_vida(value):
	super(value)
	emit_signal("nucleo_danificado", vida_atual, vida_maxima)
	
