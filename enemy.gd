extends CharacterBody2D

const SNIFF_RANGE = 100
const SPEED = 70.0
const JUMP_VELOCITY = -400.0

var lockedin = false

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var ray_cast_2d_2: RayCast2D = $RayCast2D2
@onready var ray_cast_2d_3: RayCast2D = $RayCast2D3
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D


func navigate() -> Array:
	var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
	var direction
	var jump
	if player.global_position.x > global_position.x:
		if (player.global_position.x - global_position.x > SNIFF_RANGE) and not lockedin:
			return [0, false]
		direction = 1
	else:
		if (global_position.x - player.global_position.x > SNIFF_RANGE) and not lockedin:
			return [0, false]
		direction = -1
	if ray_cast_2d.is_colliding() or ray_cast_2d_2.is_colliding():
		jump = true
	if direction:
		lockedin = true
	if not ray_cast_2d_3.is_colliding() and is_on_floor():
		jump = true
	if player.global_position.y < global_position.y:
		jump = true
	return [direction, jump]


func _physics_process(delta: float) -> void:
	var navigation = navigate()
	var direction = navigation[0]
	var jumping = navigation[1]
	if not is_on_floor():
		velocity += get_gravity() * delta

	if jumping and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("jump")

	if direction:
		velocity.x = direction * SPEED
		if not jumping:
			if direction == -1:
				anim.flip_h = true
			else:
				anim.flip_h = false
			anim.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		anim.play("idle")

	move_and_slide()
