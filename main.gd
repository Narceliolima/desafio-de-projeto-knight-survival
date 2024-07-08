extends Node

@export var game_ui: CanvasLayer
@export var game_over_scene: PackedScene
@export var game_speed: float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	Singleton.game_over.connect(trigger_game_over)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func trigger_game_over():
	#Delete o game atual
	if game_ui:
		game_ui.queue_free()
		
	#Inicia game over
	add_child(game_over_scene.instantiate())
