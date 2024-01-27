extends CharacterBody2D

var gui = null

var max_health = 100
var health = 100
var resource = 0
var t1cost = 10
var t2cost = 20
var t3cost = 30
var g1cost = 40
var g2cost = 50
var g3cost = 60
var p1time = 1.
var p2time = 2.
var maxene = 100
var avaene = 30
var useene = 0

func set_gui_handler(gui):
	self.gui = gui

func _physics_process(delta):
	if Input.is_key_pressed(KEY_Q):
		max_health = (max_health+1)%101
		gui.set_max_health_value(max_health)
		
	if Input.is_key_pressed(KEY_W):
		health = (health+1)%101
		gui.set_new_health_value(health)
		
	if Input.is_key_pressed(KEY_E):
		resource = (resource+1)%101
		gui.set_new_resource_value(resource)
		
	if Input.is_key_pressed(KEY_R):
		t1cost = (t1cost+1)%90
		t2cost = (t2cost+1)%90
		t3cost = (t3cost+1)%90
		gui.set_towers_cost_values(t1cost, t2cost, t3cost)
		
	if Input.is_key_pressed(KEY_T):
		g1cost = (g1cost+1)%90
		g2cost = (g2cost+1)%90
		g3cost = (g3cost+1)%90
		gui.set_generators_cost_values(g1cost, g2cost, g3cost)
		
	if Input.is_key_pressed(KEY_Y):
		p1time = (p1time+0.1)
		p2time = (p2time+0.1)
		if p1time > 20:
			p1time = 0
		if p2time > 20:
			p2time = 0
		gui.set_powers_max_time_values(p1time, p2time)
		
	if Input.is_key_pressed(KEY_U):
		gui.fire_p1()
		
	if Input.is_key_pressed(KEY_I):
		gui.fire_p2()
		
	if Input.is_key_pressed(KEY_O):
		maxene = (maxene+1)%101
		gui.set_max_energy_value(maxene)
		
	if Input.is_key_pressed(KEY_P):
		avaene = (avaene+1)%101
		gui.set_available_energy_value(avaene)
		
	if Input.is_key_pressed(KEY_A):
		useene = (useene+1)%101
		gui.set_used_energy_value(useene)

