extends CharacterBody2D

# for player only
const THROWABLE: PackedScene = preload("res://throwable.tscn")

@export var acceleration := 150
@export var friction := 2000
@export var gravity := 300
@export var max_speed := 500
@export var max_fall := 1000
@export var jump_strength = 300
@export var shrink_percent := 165
@export var wall_jump_bounce := 500
@export var wall_stength := 400
@export var throw_cd := 0.1
@export var shield_force = 15.0
@export var shield_radius = 15
@export var lives = 2
@export var bridge_cd = 0.3333
var curdir
var wall_side = 0.0
var is_dying := false
var wall_jump := false
var wall_direction: Vector2
var last_direction := 1
var direction := 1.0
var jump := false
var can_throw = true
var wall_jump_lock := 0.0
var can_bridge = false
var wall_slide = false
var start_pos = Vector2.ZERO
var saved_shrink_percent: int = shrink_percent
@onready var bridge_timer: Timer = $Timer2
@onready var timey: Timer = $Timer3
@onready var throw_timer = $Timer
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var hud: Control = $CanvasLayer/HUD
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var collected: Array


func _ready() -> void:
	start_pos = global_position
	throw_timer.wait_time = throw_cd
	throw_timer.timeout.connect(allow)
	throw_timer.start()
	bridge_timer.wait_time = 20
	bridge_timer.timeout.connect(disable_bridge)
	collision_shape_2d.disabled = false
	hud.change_health(lives)


func allow():
	can_throw = true


func enable_bridge(sec):
	can_bridge = true
	bridge_timer.start(sec)
	hud.add_duration_status(sec, "Press shift to bridge")


func disable_bridge():
	can_bridge = false


func _physics_process(_delta: float) -> void:
	if not is_dying:
		wall_jump_lock -= _delta
		scale -= (scale / 100.0) * ((shrink_percent / 60.0) * _delta)
		#wall_slide = false
		get_input()
		set_velocit(_delta)
		move_and_slide()
		animate()
		attack()
		bridge()
		
		if scale.x < 0.5:
			scale = Vector2(1.0,1.0)
			die()
	else:
		global_position = global_position.move_toward(start_pos, 300 * _delta)
		if global_position == start_pos:
			get_tree().call_deferred("reload_current_scene")


func animate():
	if wall_slide:
		var wall_dir = get_wall_normal()
		sprite_2d.play("WALL")
		if wall_dir.x < 0:
			sprite_2d.offset.x = 10.184
		elif wall_dir.x > 0:
			sprite_2d.offset.x = -2.816
	else:
		sprite_2d.offset.x = 4.184
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
		elif (is_on_wall() or wall_slide) and wall_jump_lock <= 0:
			wall_jump = true
			wall_direction = get_wall_normal()


func bridge():
	if Input.is_action_just_pressed("bridge"):
		if not can_bridge:
			return
		var bridgeable: PackedScene = load("res://bridgeable.tscn")
		var bridge_instance: RigidBody2D = bridgeable.instantiate()
		bridge_instance.global_position = Vector2(global_position.x, global_position.y + 10)
		get_parent().add_child(bridge_instance)
		var throw_direction = Vector2(direction, 0)
		var throw_force = 500.0
		bridge_instance.apply_central_impulse(throw_direction * throw_force)


func attack():
	if Input.is_action_just_pressed("throw"):
		if not can_throw:
			return
		can_throw = false
		throw_timer.start()
		var potion: RigidBody2D = THROWABLE.instantiate()
		potion.global_position = Vector2(
			global_position.x - (0 if last_direction == 1 else 5), global_position.y - 3
		)
		get_parent().add_child(potion)
		var throw_direction = Vector2(last_direction, 0)
		var throw_force = 500.0
		potion.apply_central_impulse(throw_direction * throw_force)


func shield():
	var count = 14

	for i in range(count):
		var potion: RigidBody2D = THROWABLE.instantiate()
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
		wall_jump_lock = 0.2
	elif wall_jump_lock <= 0:
		if direction:
			velocity.x = move_toward(velocity.x, direction * max_speed, delta * acceleration)
		else:
			velocity.x = move_toward(velocity.x, 0, friction * delta)
	if is_on_floor() or not onwall():
		wall_slide = false
		curdir = null
	if not is_on_floor():
		if is_on_wall():
			wall_side = -get_wall_normal().x
		if not is_on_wall() and not wall_slide:
			velocity.y += gravity * delta
			velocity.y = min(velocity.y, max_fall)
		else:
			if not curdir:
				curdir = last_direction
			if onwall() and wall_side == last_direction and (direction == curdir or direction == 0) and velocity.y >= 0:
				velocity.y = gravity * 0.02
				velocity.y = min(velocity.y, max_fall)
				wall_slide = true
			else:
				curdir = null
				wall_slide = false
				velocity.y += gravity * delta
				velocity.y = min(velocity.y, max_fall)
	elif jump:
		velocity.y = 0 - jump_strength
		jump = false


## Stops shrinking for a set amount of time, 15 seconds.
func stopshrinking():
	saved_shrink_percent = shrink_percent
	shrink_percent = 0
	timey.wait_time = 15
	timey.timeout.connect(resumeshrinking)
	timey.start()

## Stops shrinking indefinitely, until something restarts it with [method resumeshrinking].
func pauseshrinking():
	shrink_percent = 0

func reverseshrinking(seconds):
	scale = scale/((1-(shrink_percent/6000.0)) ** seconds)

func resumeshrinking():
	shrink_percent = saved_shrink_percent

func onwall():
	var bods = $Area2D.get_overlapping_bodies()
	for bod in bods:
		if bod.name.find("Tile") != -1:
			return true
	return false

func die(force: bool = false):
	if lives > 1 and not force:
		lives -= 1
		shield.call_deferred()
		hud.change_health(lives)
		return
	sprite_2d.play("heart")
	sprite_2d.scale = Vector2(0.14, 0.14)
	is_dying = true
	collision_shape_2d.disabled = true


func _process(delta: float) -> void:
	# Inputs that aren't physics related
	if Input.is_action_just_pressed("ui_pause") and !$CanvasLayer/PauseMenu.active:
		$CanvasLayer/PauseMenu.open()



func _collected(name):
	return collected.has(name)
