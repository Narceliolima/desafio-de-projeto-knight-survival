extends Node

@export var mob_spawner: MobSpawner
@export var initial_spawn_rate: float = 60
@export var spawn_rate_per_minute: float = 30
@export var wave_duration: float = 20
@export var break_intensity: float = 0.5

var time_in_minutes: float = 0

func _process(delta):
	#Se fim de jogo encerre
	if Singleton.is_game_over:
		queue_free()
	
	time_in_minutes += delta/60
	
	# Dificuldade "Linear"
	var spawn_rate = initial_spawn_rate + spawn_rate_per_minute * time_in_minutes
	
	# Sistema de ondas (Senoidal)
	var sin_wave = sin((time_in_minutes * TAU) / wave_duration)
	var wave_factor = remap(sin_wave, -1.0, 1.0, break_intensity, 1)
	spawn_rate *= wave_factor
	
	mob_spawner.monsters_per_minute = spawn_rate
