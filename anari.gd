extends CharacterBody2D
var player: CharacterBody2D
var targety: int
@export var offset = 100
@export var speed = 200
@export var shots_per_sec: float = 2
var deltatimer = 0
@onready var deltatimer_cooldown = 1 / shots_per_sec 
var direction = 0
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
func _physics_process(delta: float) -> void:
	if not player: return
	var playery = player.global_position.y
	var my_y = global_position.y
	if not targety or abs(my_y - targety) < 10:
		if global_position.y < playery:
			targety = playery + offset
		else:
			targety = playery - offset
	else:
		direction = sign(targety - my_y)
	if direction:
		velocity.y = direction * speed
	if deltatimer < deltatimer_cooldown:
		deltatimer += delta
	else:
		deltatimer = 0
		projectile()
	move_and_slide()

func death():
	player.bigbang()
	queue_free()

func projectile():
	var projectile: PackedScene = load("res://bossesthrowable.tscn")
	var instance: RigidBody2D = projectile.instantiate()
	get_parent().add_child(instance)
	instance.global_position = Vector2(global_position.x, global_position.y + 24)
	var direction = Vector2(-1, 0)
	var force = 150.0

	instance.apply_central_impulse(direction * force)
