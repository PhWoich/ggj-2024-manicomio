extends Estrutura

var tipo_alvo = "Jogador"
var currTargets = []
@onready var timerSpray = $TimerSpray

var gas_right

var gas_active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_timer_timeout(true)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func entrou_area_gas(lado_animated, body):
	if tipo_alvo in body.name:
		if gas_active:
			_on_timer_timeout(true)
		gas_active = true
		lado_animated.play("spray")
		timerSpray.start()
	pass # Replace with function body.

func saiu_area_gas(body):
	if tipo_alvo in body.name:
		pass # Replace with function body.

func _on_gas_body_exited(body):
	saiu_area_gas(body)
	
#### RIGHT ####
func _on_gas_right_body_entered(body):
	entrou_area_gas($gas_right/AnimatedSprite2D2, body)

#### LEFT ####
func _on_gas_left_body_entered(body):
	entrou_area_gas($gas_left/AnimatedSprite2D2, body)

#### TOP ####
func _on_gas_top_body_entered(body):
	entrou_area_gas($gas_top/AnimatedSprite2D2, body)

#### DOWN ####
func _on_gas_down_body_entered(body):
	entrou_area_gas($gas_down/AnimatedSprite2D2, body)

func activate_spray(lado_animated):
	gas_active = true
	lado_animated.play("spray")
	timerSpray.start()

func verifica_louco():
	if not(gas_active):
		if not((get_node("gas_right").get_overlapping_bodies().filter(func(body): return (tipo_alvo in body.name))).is_empty()):
			activate_spray($gas_right/AnimatedSprite2D2)
		elif not((get_node("gas_left").get_overlapping_bodies().filter(func(body): return (tipo_alvo in body.name))).is_empty()):
			activate_spray($gas_left/AnimatedSprite2D2)
		elif not((get_node("gas_top").get_overlapping_bodies().filter(func(body): return (tipo_alvo in body.name))).is_empty()):
			activate_spray($gas_top/AnimatedSprite2D2)
		elif not((get_node("gas_down").get_overlapping_bodies().filter(func(body): return (tipo_alvo in body.name))).is_empty()):
			activate_spray($gas_down/AnimatedSprite2D2)

func _on_timer_timeout(forcado=false):
	$gas_right/AnimatedSprite2D2.play("no_spray")
	$gas_left/AnimatedSprite2D2.play("no_spray")
	$gas_top/AnimatedSprite2D2.play("no_spray")
	$gas_down/AnimatedSprite2D2.play("no_spray")
	gas_active = false
	timerSpray.stop()
	if not(forcado):
		verifica_louco()
	pass # Replace with function body.
