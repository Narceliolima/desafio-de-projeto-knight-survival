class_name Enemy
extends Node2D

@export_category("Life")
@export var health: int = 5
@export var death_animation: PackedScene
@export_category("Drops")
@export var drop_chance: float = 10
@export var drop_items: Array[PackedScene]
@export var drop_chances: Array[float]

@onready var damage_digit_prefab: PackedScene = preload("res://misc/damage_value.tscn")
@onready var damage_digit_marker = $DamageDigitMarker

func damage(value: int):
	health -= value
	
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	var damage_digit = damage_digit_prefab.instantiate()
	damage_digit.value = value
	if damage_digit_marker:
		damage_digit.global_position = damage_digit_marker.global_position
	else:
		damage_digit.global_position
	get_parent().add_child(damage_digit)
	
	if health <= 0:
		die()

func die():
	#Skull
	if death_animation:
		var death_object = death_animation.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	#Drop Item
	if randf() <= drop_chance/100: #Por cento
		drop_item()
	
	Singleton.monster_count()
	
	queue_free()

func drop_item():
	var drop = get_random_drop().instantiate()
	drop.position = position
	get_parent().add_child(drop)

func get_random_drop() -> PackedScene:
	#So um item
	if drop_items.size()==1:
		return drop_items[0]
		
	#Somar todas as chaces para calcular a chance máxima
	var max_chance = 0.0
	for chance in drop_chances:
		max_chance += chance
		
	var random_number_generator = randf() * max_chance
	var pointer = 0.0
	
	for i in drop_items.size():
		if random_number_generator <= drop_chances[i] + pointer:
			return drop_items[i]
		
		pointer += drop_chances[i]
	
	return null #Vou colocar um "never reached"
