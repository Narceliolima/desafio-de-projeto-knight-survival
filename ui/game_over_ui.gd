class_name GameOverUI
extends CanvasLayer

@export var restart_delay: float = 5

@onready var time_survived_label: Label = %TSValue
@onready var monsters_defeated_label: Label = %MDValue
@onready var meat_collected_label: Label = %MCValue

var restart_cooldown: float = 0

func _ready():
	time_survived_label.text = Singleton.get_time_elapsed()
	monsters_defeated_label.text = str(Singleton.monsters_defeated)
	meat_collected_label.text = str(Singleton.meat_counter)
	restart_cooldown = restart_delay

func _process(delta):
	restart_cooldown -= delta
	if restart_cooldown <= 0:
		restart_game()

func restart_game():
	Singleton.reset()
	get_tree().reload_current_scene()
