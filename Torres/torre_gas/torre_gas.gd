extends Estrutura

var currTargets = []
@onready var timerSpray = $TimerSpray

var gas_right

var gas_active = false
var tempList
@export var forca: float = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_timer_timeout(true)

func activate_spray(lado_animated, node):
	gas_active = true
	lado_animated.play("spray")
	timerSpray.start()
	
	var currLoucos = get_node(node).get_overlapping_bodies().filter(func(body): return (body.has_method('getTeam') && (body.getTeam() == 'louco' && body.has_method('atualizar_vida')) ))
	for loucos in currLoucos:
		loucos.atualizar_vida(-forca)
		
func entrou_area_gas(lado_animated, node, body):
	if(body.has_method('getTeam')):
		if(body.getTeam() == 'louco' && body.has_method('atualizar_vida')):
			if gas_active:
				_on_timer_timeout(true)
			activate_spray(lado_animated, node)

func saiu_area_gas(body):
	print('')

func _on_gas_body_exited(body):
	saiu_area_gas(body)
	
#### RIGHT ####
func _on_gas_right_body_entered(body):
	entrou_area_gas($gas_right/AnimatedSprite2D2, "gas_right", body)

#### LEFT ####
func _on_gas_left_body_entered(body):
	entrou_area_gas($gas_left/AnimatedSprite2D2, "gas_left", body)

#### TOP ####
func _on_gas_top_body_entered(body):
	entrou_area_gas($gas_top/AnimatedSprite2D2, "gas_top", body)

#### DOWN ####
func _on_gas_down_body_entered(body):
	entrou_area_gas($gas_down/AnimatedSprite2D2, "gas_down", body)

func verifica_louco():
	if not(gas_active):
		tempList = get_node("gas_right").get_overlapping_bodies().filter(func(_body): return (_body.has_method('getTeam') && (_body.getTeam() == 'louco' && _body.has_method('atualizar_vida')) ))
		if not(tempList.is_empty()):
			activate_spray($gas_right/AnimatedSprite2D2, "gas_right")
			return 
		tempList = get_node("gas_left").get_overlapping_bodies().filter(func(_body): return (_body.has_method('getTeam') && (_body.getTeam() == 'louco' && _body.has_method('atualizar_vida')) ))
		if not(tempList.is_empty()):
			activate_spray($gas_left/AnimatedSprite2D2, "gas_left")
			return
		tempList = get_node("gas_top").get_overlapping_bodies().filter(func(_body): return (_body.has_method('getTeam') && (_body.getTeam() == 'louco' && _body.has_method('atualizar_vida')) ))
		if not(tempList.is_empty()):
			activate_spray($gas_top/AnimatedSprite2D2, "gas_top")
			return
		tempList = get_node("gas_down").get_overlapping_bodies().filter(func(_body): return (_body.has_method('getTeam') && (_body.getTeam() == 'louco' && _body.has_method('atualizar_vida')) ))
		if not(tempList.is_empty()):
			activate_spray($gas_down/AnimatedSprite2D2, "gas_down")

func _on_timer_timeout(forcado=false):
	$gas_right/AnimatedSprite2D2.play("no_spray")
	$gas_left/AnimatedSprite2D2.play("no_spray")
	$gas_top/AnimatedSprite2D2.play("no_spray")
	$gas_down/AnimatedSprite2D2.play("no_spray")
	gas_active = false
	timerSpray.stop()
	if not(forcado):
		verifica_louco()
