extends CharacterBody2D

# for player only
@export var acceleration := 500
@export var friction := 1500
@export var gravity := 300
@export var max_speed := 600
@export var max_fall := 1000
@export var jump_strength = 300
@export var shrink_percent := 5
@export var wall_jump_bounce := 500
@export var wall_stength := 300
@export var bridge_throw_cd := 0.1
@export var shield_force = 15.0
@export var shield_radius = 15

var wall_jump := false
var wall_direction: Vector2
var last_direction := 1
var direction := 1.0
var jump := false
var can_bridge_throw = true
var can_shield = true

@onready var bridge_throw_timer = $Timer
@onready var shield_timer = $Timer2
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D


func _ready() -> void:
	bridge_throw_timer.wait_time = bridge_throw_cd
	bridge_throw_timer.timeout.connect(allow)
	bridge_throw_timer.start()
	shield_timer.timeout.connect(allow_shield)


func allow_shield():
	can_shield = true


func allow():
	can_bridge_throw = true


func _physics_process(_delta: float) -> void:
	scale -= (scale / 100.0) * ((shrink_percent / 60.0) * _delta)
	get_input()
	set_velocit(_delta)
	animate()
	move_and_slide()
	attack()
	bridge()
	shield()
	
func animate():
	if velocity.x:
		sprite_2d.play("run")
	else:
		sprite_2d.play("default")


func get_input():
	direction = Input.get_axis("left", "right")
	if direction:
		last_direction = direction
		$Sprite2D.flip_h = direction < 0
	if Input.is_action_just_pressed("up"):
		if is_on_floor():
			jump = true
		elif is_on_wall():
			wall_jump = true
			wall_direction = get_wall_normal()


func bridge():
	if Input.is_action_just_pressed("bridge"):
		if not can_bridge_throw:
			return
		can_bridge_throw = false
		bridge_throw_timer.start()
		var bridgeable: PackedScene = load("res://bridgeable.tscn")
		var bridge_instance: RigidBody2D = bridgeable.instantiate()
		bridge_instance.global_position = Vector2(global_position.x, global_position.y + 10)
		get_parent().add_child(bridge_instance)
		var throw_direction = Vector2(direction, 0)
		var throw_force = 500.0
		bridge_instance.apply_central_impulse(throw_direction * throw_force)


func attack():
	if Input.is_action_just_pressed("throw"):
		if not can_bridge_throw:
			return
		can_bridge_throw = false
		bridge_throw_timer.start()
		var throwable: PackedScene = load("res://throwable.tscn")
		var potion: RigidBody2D = throwable.instantiate()
		potion.global_position = Vector2(global_position.x - (0 if last_direction == 1 else 5), global_position.y -3)
		get_parent().add_child(potion)
		var throw_direction = Vector2(last_direction, 0)
		var throw_force = 500.0
		potion.apply_central_impulse(throw_direction * throw_force)


func shield():
	if Input.is_action_just_pressed("shield"):
		if not can_shield:
			return
		can_shield = false
		shield_timer.start()
		var throwable: PackedScene = load("res://throwable.tscn")
		var count = 14

		for i in range(count):
			var potion: RigidBody2D = throwable.instantiate()
			var angle = TAU * i / count
			var offset = Vector2(cos(angle), sin(angle)) * shield_radius
			potion.global_position = global_position + offset
			get_parent().add_child(potion)
			var throw_direction = offset.normalized()

			potion.apply_central_impulse(throw_direction * shield_force)


func set_velocit(delta):
	if wall_jump:
		velocity.x = wall_direction.x * wall_jump_bounce
		velocity.y = -wall_stength
		wall_jump = false
	else:
		if direction:
			velocity.x = move_toward(velocity.x, direction * max_speed, delta * acceleration)
		else:
			velocity.x = move_toward(velocity.x, 0, friction * delta)

	if not is_on_floor():
		if not is_on_wall():
			velocity.y += gravity * delta
			velocity.y = min(velocity.y, max_fall)
		else:
			velocity.y = gravity* 0.07
			velocity.y = min(velocity.y, max_fall)
	elif jump:
		velocity.y = 0 - jump_strength
		jump = false


func die():
	$AnimationPlayer.play("die")
	await $AnimationPlayer.animation_finished
	get_tree().call_deferred("reload_current_scene")
