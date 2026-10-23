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

var direction := 1
var jump := false




func _physics_process(_delta: float) -> void:
	scale -= (scale/100)*((ShrinkPercent/60)*_delta)
	get_input()
	set_velocit(_delta)
	move_and_slide()


func get_input():
	direction = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("up"):
		if is_on_floor():
			jump = true
		elif is_on_wall():
			wall_jump = true
			wall_direction = get_wall_normal()


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
	
	
