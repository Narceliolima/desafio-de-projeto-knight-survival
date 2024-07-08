class_name MobSpawner
extends Node2D

@export var creatures: Array[PackedScene]

@onready var path_follow_2d: PathFollow2D = %PathFollow2D

var cooldown: float = 0
var monsters_per_minute: float = 60

func _process(delta):
		#Se fim de jogo encerre
	if Singleton.is_game_over:
		queue_free()
		
	cooldown -= delta
	if cooldown > 0: return
	
	var interval = 60 / monsters_per_minute
	cooldown = interval
	
	get_parent().add_child(generate_random_creature())

func get_random_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
	
#Verifica a existencia de um corpo, usado para evitar spawn de monstro nos limites da tela
func get_point() -> Vector2:
	
	var point = get_random_point()
	
	while(verify_body_exist(point)):
		point = get_random_point()
	
	return point

func verify_body_exist(point: Vector2) -> bool:
	
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	parameters.collision_mask = 0b1001
	var result: Array =  world_state.intersect_point(parameters, 1)
	
	return !result.is_empty()	

func generate_random_creature() -> Node2D:
	
	var index = randi_range(0, creatures.size() -1)
	var creature = creatures[index].instantiate()
	creature.global_position = get_point()
	
	return creature
