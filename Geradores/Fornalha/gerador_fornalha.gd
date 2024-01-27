extends Gerador_Basico


func _ready():
	custo_base = 25
	energia_gerada = 30.0
	$AnimatedSprite2D.play("default")
	super()
