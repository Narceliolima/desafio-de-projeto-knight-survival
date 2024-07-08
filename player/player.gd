class_name Player
extends CharacterBody2D

@export_category("Movement")
@export var speed: float = 3
@export_category("Player Damage")
@export var sword_damage: int = 1
@export var ritual_damage: int = 1
@export var ritual_interval: float = 20
@export var ritual_scene: PackedScene
@export_category("Player Health")
@export var health: int = 5
@export var health_limit: int = 5
@export var death_animation: PackedScene

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_sprite = $PlayerSprite
@onready var sword_area = $SwordArea
@onready var damage_area = $DamageArea
@onready var health_bar = $HealthBar

var is_running: bool = false
var is_attacking: bool = false
var input_vector: Vector2
var attack_speed: float = 0.0
var hitbox_cooldown: float = 0.0
var ritual_cooldown: float = 20

signal meat_collected()

func _ready():
	Singleton.player = self
	speed *= get_parent().game_speed

func _process(delta: float) -> void:
	
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#ajust_deadzone(input_vector, 0.15) #Ajustar deadzone de joystick
	
	Singleton.player_position = position
	animate_player()
	player_direction()
	animate_attack()
	execute_attack(delta)
	execute_area_of_damage(delta)
	update_ritual(delta)
	update_health_bar()

func _physics_process(delta: float) -> void:

	var max_velocity = input_vector * speed * 100
	print(speed)
	if is_attacking:
		max_velocity *= 0.3
	
	velocity = lerp(velocity, max_velocity, 0.3)
	move_and_slide()

func animate_player() -> void:
	
	if !is_attacking:
		if input_vector.is_zero_approx() != is_running:
			if is_running:
				animation_player.play("run")
				is_running=false
			else:
				animation_player.play("idle")
				is_running=true

func player_direction():
	
	if !is_attacking:
		if input_vector.x > 0:
			player_sprite.flip_h = false
		elif input_vector.x < 0:
			player_sprite.flip_h = true

func animate_attack() -> void:
	
	if is_attacking:
		return
		
	if Input.is_action_just_pressed("attack"):
		animation_player.play("attack_slash")
		attack_speed = 0.6
		is_attacking = true

func execute_attack(delta: float) -> void:
	if is_attacking:
		attack_speed -= delta
		if(attack_speed <= 0.000):
			is_attacking = false
			is_running = true
			animation_player.play("idle")

func deal_damage_to_enemies():
	
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var enemy_direction = (enemy.position - position).normalized()
			var attack_direction: Vector2
			
			if player_sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			
			var dot_product = enemy_direction.dot(attack_direction)
			if dot_product >= 0.5:
				enemy.damage(sword_damage)

func execute_area_of_damage(delta: float):
	
	hitbox_cooldown -= delta
	
	if hitbox_cooldown > 0:
		return
		
	hitbox_cooldown = 0.5
	
	var bodies = damage_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			#var enemy: Enemy = body
			damage(1)

func damage(value: int):
	if health <=0:
		return
	
	health -= value
	
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	if health <= 0:
		die()

func update_health_bar():
	health_bar.max_value = health_limit
	health_bar.value = health

func die():
	
	if death_animation:
		var death_object = death_animation.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
		
		Singleton.end_game()
	
	queue_free()

func heal(value: int) -> int:
	
	if health + value > health_limit:
		health = health_limit
	else:
		health += value
	
	Singleton.meat_count()
	meat_collected.emit()
	
	return health

func update_ritual(delta: float):
	ritual_cooldown -= delta
	if ritual_cooldown > 0: return
	
	ritual_cooldown = ritual_interval
	
	var ritual = ritual_scene.instantiate()
	ritual.damage_value = ritual_damage
	add_child(ritual)

func ajust_deadzone(input: Vector2, deadzone_valor: float) -> void:
	if abs(input.x) < deadzone_valor:
		input.x = 0
	if abs(input.y) < deadzone_valor:
		input.y = 0

#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("move_right"):
		#if is_running:
			#animation_player.play("idle")
			#is_running = false;
		#else:
			#animation_player.play("run")
			#is_running = true
