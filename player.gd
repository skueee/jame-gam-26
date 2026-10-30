extends CharacterBody2D

# for player only
const THROWABLE: PackedScene = preload("res://throwable.tscn")
var banging = false
@export var acceleration := 200
@export var friction := 2000
@export var gravity := 980
@export var max_speed := 600
@export var max_fall := 2000
@export var jump_strength = 300
@export var shrink_percent := 50
@export var wall_jump_bounce := 100
@export var wall_stength := 400
@export var throw_cd := 0.1
@export var shield_force = 10.0
@export var shield_radius = 15
@export var lives = 2
@export var bridge_cd = 0.3333
@export var supersense_cd = 10
var supercdtimer = 5
var supertimer = 0
var supersensing = false
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
var god_mode := false
var shop := false
var close_shop := false
var instance
var shop_scene = preload("res://Shop.tscn")
var bridgeable: PackedScene = preload("res://bridgeable.tscn")
@onready var bridge_timer: Timer = $Timer2
@onready var timey: Timer = $Timer3
@onready var throw_timer = $Timer
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var hud: Control = $CanvasLayer/HUD
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var collected: Array
@onready var timer_4: Timer = $Timer4
@onready var bang_rect: ColorRect = $CanvasLayer/Bang/ColorRect
@onready var speed_boost: Timer = $"Speed Boost"
@onready var pause_menu: Control = $CanvasLayer/PauseMenu
@onready var camera_2d: Camera2D = $Camera2D



func _ready() -> void:
	start_pos = global_position
	throw_timer.wait_time = throw_cd
	throw_timer.timeout.connect(allow)
	throw_timer.start()
	bridge_timer.wait_time = 20
	bridge_timer.timeout.connect(disable_bridge)
	collision_shape_2d.disabled = false
	hud.change_health(lives)
	timer_4.one_shot = true
	timer_4.wait_time = 5
	timer_4.timeout.connect(final)
	Engine.time_scale = 1
	Die.speed_booster.connect(boost_speed)
	Die.greater_jump.connect(greater_jump)
	Die.extra_life.connect(extra_life)


func extra_life():
	lives += 1
	hud.change_health(lives)


func greater_jump():
	await Die.pause_close
	jump_strength *= 1.5
	hud.add_duration_status(10, "Jump Boosterss")
	await get_tree().create_timer(10).timeout
	jump_strength *= 0.6667

func boost_speed():
	await Die.pause_close
	max_speed *= 1.5
	acceleration *= 1.5
	hud.add_duration_status(10, "Speed Booster")
	await get_tree().create_timer(10).timeout
	max_speed *= 0.667
	acceleration *= 0.667



func final():
	get_tree().change_scene_to_file("res://endscreendevil.tscn")

func allow():
	can_throw = true


func enable_bridge(sec):
	can_bridge = true
	bridge_timer.start(sec)
	hud.add_duration_status(sec, "Press shift to bridge")


func disable_bridge():
	can_bridge = false


func _physics_process(_delta: float) -> void:
	if banging:
		bang_rect.modulate.a += 1 * _delta
	if not shop:
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
	else:
		if close_shop:
			instance.queue_free()
			close_shop = false
			shop = false
			camera_2d.zoom = Vector2(3, 3)

func open_shop():
	instance = shop_scene.instantiate()
	add_child(instance)
	camera_2d.zoom = Vector2.ONE
	


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
		if is_on_floor() || god_mode:
			jump = true
		elif (is_on_wall() or wall_slide) and wall_jump_lock <= 0:
			wall_jump = true
			wall_direction = get_wall_normal()
	if Input.is_action_just_pressed("God"):
		god_mode = not god_mode
	if Input.is_action_just_pressed("ui_pause"):
		if shop:
			close_shop = true
		else:
			pass
	if Input.is_action_just_pressed('Shop'):
		shop = true
		open_shop()

func bridge():
	if Input.is_action_just_pressed("bridge"):
		if not can_bridge:
			return
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
	var on_floor = is_on_floor()
	var on_wall = is_on_wall()
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
	if on_floor or not on_wall:
		wall_slide = false
		curdir = null
	if not god_mode:
		if not on_floor:
			if on_wall:
				wall_side = -get_wall_normal().x
			if not on_wall and not wall_slide:
				velocity.y += gravity * delta
				velocity.y = min(velocity.y, max_fall)
			else:
				if not curdir:
					curdir = last_direction
				if on_wall and wall_side == last_direction and (direction == curdir or direction == 0) and velocity.y >= 0:
					velocity.y = gravity * 0.02
					velocity.y = min(velocity.y, max_fall)
					wall_slide = true
				else:
					curdir = null
					wall_slide = false
				velocity.y += gravity * delta
				velocity.y = min(velocity.y, max_fall)
				if on_wall and wall_side == last_direction and (direction == curdir or direction == 0) and velocity.y >= 0:
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
	elif jump:
		position.y -= 10
		jump = false

func camerashake():
	$Camera2D.shake(true)

func bigbang():
	banging = true
	$Camera2D.shake()
	timer_4.start()

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

func die(force: bool = false):
	if banging: return
	if lives > 1 and not force:
		lives -= 1
		shield.call_deferred()
		hud.change_health(lives)
		return
	sprite_2d.play("heart")
	sprite_2d.scale = Vector2(0.14, 0.14)
	is_dying = true
	collision_shape_2d.disabled = true
	Die.emit_signal("die")
	Die.coins = 0

func _process(delta: float) -> void:
	supercdtimer += delta
	if Input.is_action_just_pressed("supersense"):
		if supercdtimer < supersense_cd: return
		if not supersensing:

			supersensing = true
			Engine.time_scale = 0.5
			hud.add_duration_status(5, "Super Sensing")
	if supersensing:
		if supertimer < 5:
			supertimer += delta
		else:
			supertimer = 0
			supercdtimer = 0
			supersensing = false
			Engine.time_scale = 1

	# Inputs that aren't physics related
	if Input.is_action_just_pressed("ui_pause") and !$CanvasLayer/PauseMenu.active:
		$CanvasLayer/PauseMenu.open()



func _collected(name):

	return collected.has(name)
