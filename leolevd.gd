extends CharacterBody2D
# this will be the most complex ai byfar (foreshadowing?)
@export var ultimate_target: CharacterBody2D
@export var max_speed: int = 300
@export var acceleration: int = 300
@export var slowingss: int = 8000
@export var tilemap: TileMapLayer
@onready var start_y = global_position.y
@export var shots_per_sec: float = 5
var statespassed = 0
var targetstates = 6
var deltatimer = 0
@onready var deltatimer_cooldown = 1 / shots_per_sec 
var timer = 0
var timer2 = 0
var timer3 = 0
var state = "idle"
var states = ["idle", "chasing", "shooting", "summoning"]
var target_pos = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not ultimate_target:
		ultimate_target = get_tree().get_first_node_in_group("player")

func summon():
	var projectile: PackedScene = load("res://theranger.tscn")
	var instance: CharacterBody2D = projectile.instantiate()
	get_parent().add_child(instance)
	instance.state = "chasing"
	instance.livetime = 5
	instance.max_speed = 200
	instance.global_position = Vector2(global_position.x + randi_range(-50, 50), global_position.y)

func die():
	pass

func choosestate():
	statespassed += 1
	if statespassed == targetstates:
		die()
	if randi_range(1, 2) == 1:
		state = "chasing"
	elif randi_range(1, 4) <= 3:
		state = "shooting"
	else:
		state = "summoning"

func projectile():
	var projectile: PackedScene = load("res://bossesthrowable.tscn")
	var instance: RigidBody2D = projectile.instantiate()
	get_parent().add_child(instance)
	instance.global_position = Vector2(global_position.x, global_position.y + 24)
	var direction = Vector2(0, 1)
	var force = 150.0
	instance.apply_central_impulse(direction * force)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var directionx = 0
	var directiony = 0
	var direction_to_go = Vector2(0,0)
	if timer3 < 10:
		timer3 += delta
	else:
		choosestate()
		timer3 = 0
	if state == "idle":
		if global_position.distance_to(ultimate_target.global_position) < 100:
			choosestate()
	elif state == "chasing":
		direction_to_go = global_position.direction_to(ultimate_target.global_position)
		directionx = direction_to_go.x
		directiony = direction_to_go.y
	elif state == "shooting":
		direction_to_go = global_position.direction_to(Vector2(ultimate_target.global_position.x, start_y))
		directionx = direction_to_go.x
		directiony = direction_to_go.y
		if deltatimer < deltatimer_cooldown:
			deltatimer += delta
		else:
			deltatimer = 0
			projectile()
	elif state == "summoning":
		summon()
		choosestate()
	if directionx:
			velocity.x = move_toward(velocity.x, directionx * max_speed, delta * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, slowingss * delta)
	if directiony:
			velocity.y = move_toward(velocity.y, directiony * max_speed, delta * acceleration)
	else:
		velocity.y = move_toward(velocity.y, 0, slowingss * delta)
	move_and_slide()
