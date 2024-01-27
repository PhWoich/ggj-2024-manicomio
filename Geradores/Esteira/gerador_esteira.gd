extends Gerador_Basico


# Called when the node enters the scene tree for the first time.
func _ready():
	custo_base = 10
	energia_gerada = 15.0
	$AnimatedSprite2D.play("default")
	super()
