extends Node

signal game_over

var player: Player
var player_position: Vector2
var is_game_over: bool = false
var time_elapsed: float = 0
var meat_counter: int = 0
var monsters_defeated: int = 0

func time_tick(delta):
	#ex de formatação godot "%02d:%02d" % [20,30] > 20:30
	time_elapsed += delta

func meat_count():
	
	meat_counter += 1

func monster_count():
	
	monsters_defeated += 1
	
func _process(delta):
	
	time_tick(delta)

func get_time_elapsed() -> String:
	return Time.get_time_string_from_unix_time(time_elapsed).substr(3,7)

func end_game():
	
	if is_game_over: return
	
	is_game_over = true
	game_over.emit()

func reset():
	
	player = null
	player_position = Vector2.ZERO
	is_game_over = false
	time_elapsed = 0
	meat_counter = 0
	monsters_defeated = 0
	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)
