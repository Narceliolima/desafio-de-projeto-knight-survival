extends Node2D

@export var regeneration_value: int = 4

func _ready():
	
	$Area2D.body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D):
	
	if body.is_in_group("player"):
		var player_body: Player = body
		player_body.heal(regeneration_value)
		player_body.meat_collected.emit()
		
		queue_free()
