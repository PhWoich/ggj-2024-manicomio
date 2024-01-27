extends Gerador_Basico


func _ready():
	custo_base = 60
	energia_gerada = 45.0
	$AnimatedSprite2D.play("default")
	super()
