extends CharacterBody2D
var can_beam = true
var can_projectile = true
@export var tilemap: TileMapLayer
@export var SPEED: int = 100
@onready var timer: Timer = $Timer
@onready var timer_2: Timer = $Timer2
@onready var timer_3: Timer = $Timer3
@onready var beam_foreshadowing: Sprite2D = $beam_foreshadowing
@onready var beamnode: Area2D = $beam
@onready var timer_4: Timer = $Timer4
@onready var booom: GPUParticles2D = $BOOOM
@onready var deathtime: Timer = $deathtime
var died = false
var dying = false
var hp = 100
func _ready() -> void:
	timer.one_shot = true
	timer_2.one_shot = true
	timer_3.one_shot = true
	timer_4.one_shot = true
	timer.wait_time = 3
	timer.timeout.connect(enable_beam)
	timer_2.wait_time = 1
	timer_2.timeout.connect(enable_projectile)
	timer_3.wait_time = 1
	timer_3.timeout.connect(beam)
	timer_4.wait_time = 1
	timer_4.timeout.connect(unbeam)
	deathtime.wait_time = 3
	deathtime.timeout.connect(delete)


func enable_beam():
	can_beam = true


func enable_projectile():
	can_projectile = true


func navigate() -> Array:
	var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
	var direction
	var beamattack
	var projectileattack
	if not player:
		return [0, false, false]
	if player.global_position.x > global_position.x:
		direction = 1
	elif player.global_position.x < global_position.x:
		direction = -1
	else:
		direction = 0
	if max(player.global_position.x, global_position.x) - min(player.global_position.x, global_position.x) < 15:
		beamattack = true
	elif (
		(
			max(player.global_position.x, global_position.x)
			- min(player.global_position.x, global_position.x)
		)
		< 60
	):
		projectileattack = true
	return [direction, beamattack, projectileattack]


func _physics_process(delta: float) -> void:
	var navigation = navigate()
	var direction = navigation[0]
	var beamattack = navigation[1]
	var projectileattack = navigation[2]
	if dying:
		velocity.y += 980 * delta
		direction = 0
		beamattack = false
		projectileattack = false
		if is_on_floor() and not died:
			died = true
			booom.emitting = true
			deathtime.start()
		move_and_slide()
		return
	global_position.y = -32
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if beamattack and can_beam:
		can_beam = false
		beam_foreshadowing.visible = true
		timer_3.start()
	elif projectileattack and can_projectile:
		can_projectile = false
		timer_2.start()
		projectile()
	move_and_slide()


func delete():
	tilemap.set_cell(Vector2i(3, -1), -1)
	tilemap.set_cell(Vector2i(3, 0), -1)
	tilemap.set_cell(Vector2i(3, 1), -1)
	tilemap.set_cell(Vector2i(3, 2), -1)
	tilemap.set_cell(Vector2i(7, -1), -1)
	tilemap.set_cell(Vector2i(7, 0), -1)
	tilemap.set_cell(Vector2i(7, 1), -1)
	tilemap.set_cell(Vector2i(7, 2), -1)

func die():
	if hp > 0:
		hp -= 10
		print(hp)
	else:
		dying = true

func beam():
	beam_foreshadowing.visible = false
	beamnode.visible = true
	beamnode.get_child(1).disabled = false
	timer_4.start()


func unbeam():
	beamnode.visible = false
	beamnode.get_child(1).disabled = true
	timer.start()


func projectile():
	var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
	var projectile: PackedScene = load("res://bossesthrowable.tscn")
	var instance: RigidBody2D = projectile.instantiate()
	get_parent().add_child(instance)
	instance.global_position = Vector2(global_position.x, global_position.y +24)
	var direction = (player.global_position - instance.global_position).normalized()
	var force = 300.0

	instance.apply_central_impulse(direction * force)
