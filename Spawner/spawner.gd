extends Node2D

# Para iniciar:
# Colocar o raio e o cooldown no inspetor de propriedades
# No Script principal
#@onready var spawner = $Spawner
#@onready var enemyholder = $enemyholder
#@onready var enemy1 = preload("res://Geradores/Basico/gerador_basico.tscn")
#@onready var enemy2 = preload("res://Particulas/Eletricidade/particula_eletricidade.tscn")
#@onready var enemy3 = preload("res://Particulas/Explosão Penas/explosao_penas.tscn")
#
#spawner.initialize_entityHolder(enemyholder)
#spawner.add_entity(enemy1, 1)
#spawner.add_entity(enemy2, 1) 
#spawner.add_entity(enemy3, 1)
# os inimigos podem ser adicionados aos poucos tornando o jogo mais difícil com o tempo
# o segundo numero é a chance de aparecer, ele só sorteia um número entre 0 e a soma das chances
# nesse caso cada inimigo tem 1/3 de chance
# se fosse 1,2,3 as chances o primeiro teria chance de 1/6, o segundo de 2/6 e o terceiro de 3/6

@export var radius: float = 128.0
@export var cooldown: float = 5.

@onready var timer = $Timer

var entityHolder = null
var Entitys: Array[PackedScene]
var chances: Array[int]
var totalChance: int = 0
var running = true
var num_entities = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if timer.is_stopped() and running:
		spawn()
		timer.wait_time = randf_range(1.,cooldown)
		timer.start()

func start():
	if running == false:
		timer.wait_time = randf_range(1.,cooldown)
		timer.start()
		running = true
	
func stop():
	if running == true:
		timer.stop()
		running = false
	
func initialize_entityHolder(entityHolder):
	self.entityHolder = entityHolder

func sum(accum, number):
	return accum + number
	
func add_entity(entity, chance):
	Entitys.append(entity)
	chances.append(chance)
	totalChance += chance
	num_entities += 1
	
func spawn():
	var sorteado = randi_range(0,totalChance-1)
	var acc = 0
	for i in range(num_entities):
		acc += chances[i]
		if sorteado < acc:
			sorteado = i
			break
	if entityHolder and num_entities>0:
		var entity_instance = Entitys[sorteado].instantiate()
		entityHolder.add_child(entity_instance)
		entity_instance.global_position = global_position + Vector2(randf_range(-radius,+radius), randf_range(-radius,+radius))
	
	
