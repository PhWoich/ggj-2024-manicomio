extends CanvasLayer

@onready var resourceLabel = $MarginContainer/MainHBox/Rows/TopRow/ResourceContainer/ResourceLabel

@onready var t1 = $MarginContainer/MainHBox/Rows/BottomRow/VBoxContainer/HBoxContainer3/T1
@onready var t2 = $MarginContainer/MainHBox/Rows/BottomRow/VBoxContainer/HBoxContainer3/T2
@onready var t3 = $MarginContainer/MainHBox/Rows/BottomRow/VBoxContainer/HBoxContainer3/T3
@onready var g1 = $MarginContainer/MainHBox/Rows/BottomRow/VBoxContainer/HBoxContainer3/G1
@onready var g2 = $MarginContainer/MainHBox/Rows/BottomRow/VBoxContainer/HBoxContainer3/G2
@onready var g3 = $MarginContainer/MainHBox/Rows/BottomRow/VBoxContainer/HBoxContainer3/G3
@onready var list_estruturas = [t1, t2, t3, g1, g2, g3]

@onready var tower1Img = $MarginContainer/MainHBox/Rows/BottomRow/VBoxContainer/HBoxContainer/Tower1Img
@onready var tower1Cost = $MarginContainer/MainHBox/Rows/BottomRow/VBoxContainer/HBoxContainer/Tower1Img/T1Cost
@onready var tower2Img = $MarginContainer/MainHBox/Rows/BottomRow/VBoxContainer/HBoxContainer/Tower2Img
@onready var tower2Cost = $MarginContainer/MainHBox/Rows/BottomRow/VBoxContainer/HBoxContainer/Tower2Img/T2Cost
@onready var tower3Img = $MarginContainer/MainHBox/Rows/BottomRow/VBoxContainer/HBoxContainer/Tower3Img
@onready var tower3Cost = $MarginContainer/MainHBox/Rows/BottomRow/VBoxContainer/HBoxContainer/Tower3Img/T3Cost

@onready var gen1Img = $MarginContainer/MainHBox/Rows/BottomRow/VBoxContainer/HBoxContainer2/Gen1Img
@onready var gen1Cost = $MarginContainer/MainHBox/Rows/BottomRow/VBoxContainer/HBoxContainer2/Gen1Img/Gen1Cost
@onready var gen2Img = $MarginContainer/MainHBox/Rows/BottomRow/VBoxContainer/HBoxContainer2/Gen2Img
@onready var gen2Cost = $MarginContainer/MainHBox/Rows/BottomRow/VBoxContainer/HBoxContainer2/Gen2Img/Gen2Cost
@onready var gen3Img = $MarginContainer/MainHBox/Rows/BottomRow/VBoxContainer/HBoxContainer2/Gen3Img
@onready var gen3Cost = $MarginContainer/MainHBox/Rows/BottomRow/VBoxContainer/HBoxContainer2/Gen3Img/Gen3Cost

@onready var healthLabel = $MarginContainer/MainHBox/Rows/BottomRow/HealthContainer/HealthLabel
@onready var healthBar = $MarginContainer/MainHBox/Rows/BottomRow/HealthContainer/HealthBar

@onready var power1CD = $MarginContainer/MainHBox/Rows/BottomRow/Power1Img/P1Cooldown
@onready var power1Timer = $MarginContainer/MainHBox/Rows/BottomRow/Power1Img/P1Timer

@onready var power2CD = $MarginContainer/MainHBox/Rows/BottomRow/Power2Img/P2Cooldown
@onready var power2Timer = $MarginContainer/MainHBox/Rows/BottomRow/Power2Img/P2Timer

@onready var energyLabel = $MarginContainer/MainHBox/EnergyContainer/EnergyLabel
@onready var energyYellowBar = $MarginContainer/MainHBox/EnergyContainer/EnergyBarContainer/YellowEnergyBar
@onready var energyRedBar = $MarginContainer/MainHBox/EnergyContainer/EnergyBarContainer/RedEnergyBar

@onready var central_tower_health_bar = $MarginContainer/MainHBox/Rows/TopRow/CentralHealthContainer/HealthBar
@onready var central_tower_label = $MarginContainer/MainHBox/Rows/TopRow/CentralHealthContainer/HBoxContainer/HealthValue

var resource = 10

var max_health = 100
var actual_health = 100
var available_energy = 0
var used_energy = 0

var t1Cost = 30
var t2Cost = 30
var t3Cost = 30

var g1Cost = 30
var g2Cost = 30
var g3Cost = 30

func set_new_selected_estructure(value):
	for e in list_estruturas:
		e.hide()
		
	list_estruturas[value].show()
	
func set_new_health_value(new_health: float, new_max_health: float):
	max_health = new_max_health
	healthBar.max_value = max_health
	actual_health = new_health
	healthLabel.text = "%3d / %3d" % [actual_health, max_health]
	healthBar.value = actual_health


func set_central_tower_health(new_health: float, new_max_health: float):
	central_tower_health_bar.max_value = new_max_health
	central_tower_health_bar.value = new_health
	
	central_tower_label.text = "%3d / %3d" % [new_health, new_max_health]


func set_new_resource_value(new_resource: int):
	resourceLabel.text = "%3d" % [new_resource]
	resource = new_resource
	
	if resource <= t1Cost:
		tower1Img.modulate = Color(0.5,0.5,0.5)
	else:
		tower1Img.modulate = Color(1,1,1)
	if resource <= t2Cost:
		tower2Img.modulate = Color(0.5,0.5,0.5)
	else:
		tower2Img.modulate = Color(1,1,1)
	if resource <= t3Cost:
		tower3Img.modulate = Color(0.5,0.5,0.5)
	else:
		tower3Img.modulate = Color(1,1,1)
		
	if resource <= g1Cost:
		gen1Img.modulate = Color(0.5,0.5,0.5)
	else:
		gen1Img.modulate = Color(1,1,1)
	if resource <= g2Cost:
		gen2Img.modulate = Color(0.5,0.5,0.5)
	else:
		gen2Img.modulate = Color(1,1,1)
	if resource <= g3Cost:
		gen3Img.modulate = Color(0.5,0.5,0.5)
	else:
		gen3Img.modulate = Color(1,1,1)

func set_towers_cost_values(new_T1Cost: int, new_T2Cost: int, new_T3Cost: int):
	tower1Cost.text = "%2d" % [new_T1Cost]
	tower2Cost.text = "%2d" % [new_T2Cost]
	tower3Cost.text = "%2d" % [new_T3Cost]
	t1Cost = new_T1Cost
	t2Cost = new_T2Cost
	t3Cost = new_T3Cost
	
	if resource <= t1Cost:
		tower1Img.modulate = Color(0.5,0.5,0.5)
	else:
		tower1Img.modulate = Color(1,1,1)
	if resource <= t2Cost:
		tower2Img.modulate = Color(0.5,0.5,0.5)
	else:
		tower2Img.modulate = Color(1,1,1)
	if resource <= t3Cost:
		tower3Img.modulate = Color(0.5,0.5,0.5)
	else:
		tower3Img.modulate = Color(1,1,1)
	
func set_generators_cost_values(new_G1Cost: int, new_G2Cost: int, new_G3Cost: int):
	gen1Cost.text = "%2d" % [new_G1Cost]
	gen2Cost.text = "%2d" % [new_G2Cost]
	gen3Cost.text = "%2d" % [new_G3Cost]
	g1Cost = new_G1Cost
	g2Cost = new_G2Cost
	g3Cost = new_G3Cost
	
	if resource <= g1Cost:
		gen1Img.modulate = Color(0.5,0.5,0.5)
	else:
		gen1Img.modulate = Color(1,1,1)
	if resource <= g2Cost:
		gen2Img.modulate = Color(0.5,0.5,0.5)
	else:
		gen2Img.modulate = Color(1,1,1)
	if resource <= g3Cost:
		gen3Img.modulate = Color(0.5,0.5,0.5)
	else:
		gen3Img.modulate = Color(1,1,1)

func fire_p1(_a, _b, _c, cooldown):
	power1Timer.wait_time = cooldown
	power1CD.max_value = cooldown
	power1Timer.start()
	
func fire_p2(_a, _b, _c, cooldown):
	power2Timer.wait_time = cooldown
	power2CD.max_value = cooldown
	power2Timer.start()

func set_max_energy_value(new_maxEnergy: int):
	energyYellowBar.max_value = new_maxEnergy
	energyRedBar.max_value = new_maxEnergy

func set_available_energy_value(new_availableEnergy: int):
	available_energy = new_availableEnergy
	energyYellowBar.value = available_energy
	energyLabel.text = "%3d/%3d" % [used_energy, available_energy]
	
func set_used_energy_value(new_usedEnergy: int):
	used_energy = new_usedEnergy
	energyRedBar.value = used_energy
	energyLabel.text = "%3d/%3d" % [used_energy, available_energy]
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	power1CD.value = power1Timer.time_left
	power2CD.value = power2Timer.time_left
