extends Node

@export var speed: float = 2
var input_vector: Vector2
var enemy_sprite: AnimatedSprite2D
var enemy: Enemy

func _ready():
	enemy = get_parent()
	enemy_sprite = enemy.get_node("AnimatedSprite2D")
	speed *= get_node("/root/Main").game_speed

func _process(delta: float):
	
	enemy_direction()


func _physics_process(delta: float):
	#Se fim de jogo encerre
	#if Singleton.is_game_over:
		#queue_free()
		
	var player_position = Singleton.player_position
	var diference = player_position - enemy.position
	input_vector = diference.normalized()
	
	enemy.velocity = input_vector * speed * 100
	
	enemy.move_and_slide()


func enemy_direction():

	if input_vector.x > 0:
		enemy_sprite.flip_h = false
	elif input_vector.x < 0:
		enemy_sprite.flip_h = true
