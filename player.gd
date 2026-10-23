extends CharacterBody2D

# for player only
@export var acceleration := 500
@export var friction := 1500
@export var gravity := 300
@export var max_speed := 600
@export var max_fall := 1000
@export var jump_strength = 300
@export var ShrinkPercent := 5
@export var wall_jump_bounce := 500
@export var wall_stength := 300
var wall_jump := false
var wall_direction: Vector2
var last_direction := 1
var direction := 1
var jump := false
@export var bridge_throw_cd := 0.1
@export var shield_force = 15.0
@export var shield_radius = 15
var can_bridge_throw = true
@onready var bridge_throw_timer = $Timer
@onready var shield_timer = $Timer2
var can_shield = true
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
	scale -= (scale/100)*((ShrinkPercent/60)*_delta)
	get_input()
	set_velocit(_delta)
	move_and_slide()
	attack()
	bridge()
	shield()


func get_input():
	direction = Input.get_axis("left", "right")
	if direction:
		last_direction = direction
	if Input.is_action_just_pressed("up"):
		if is_on_floor():
			jump = true
		elif is_on_wall():
			wall_jump = true
			wall_direction = get_wall_normal()
func bridge():
	if Input.is_action_just_pressed("bridge"):
		if not can_bridge_throw: return
		can_bridge_throw = false
		bridge_throw_timer.start()
		var bridgeable: PackedScene = load("res://bridgeable.tscn")
		var bridge: RigidBody2D = bridgeable.instantiate()
		bridge.global_position = Vector2(global_position.x, global_position.y+10)
		get_parent().add_child(bridge)
		var throw_direction = Vector2(direction, 0)
		var throw_force = 500.0
		bridge.apply_central_impulse(throw_direction * throw_force)

func attack():
	if Input.is_action_just_pressed("throw"):
		if not can_bridge_throw: return
		can_bridge_throw = false
		bridge_throw_timer.start()
		var throwable: PackedScene = load("res://throwable.tscn")
		var potion: RigidBody2D = throwable.instantiate()
		potion.global_position = global_position
		get_parent().add_child(potion)
		var throw_direction = Vector2(last_direction, 0)
		var throw_force = 500.0
		potion.apply_central_impulse(throw_direction * throw_force)

func shield():
	if Input.is_action_just_pressed("shield"):
		if not can_shield: return
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
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_fall)
	elif jump:
		velocity.y = 0 - jump_strength
		jump = false

func die():
	get_tree().reload_current_scene()
	
	
