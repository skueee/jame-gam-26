extends CharacterBody2D

# for player only
@export var acceleration := 500
@export var friction := 1500
@export var gravity := 300
@export var max_speed := 600
@export var max_fall := 1000
@export var jump_strength = 300

var direction := 1
var jump := false

func _physics_process(_delta: float) -> void:
	get_input()
	set_velocit(_delta)
	move_and_slide()


func get_input():
	direction = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("up") and is_on_floor():
		jump = true


func set_velocit(delta):
	if direction:
		velocity.x = move_toward(velocity.x, direction*max_speed, delta*acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, friction*delta)
	if not is_on_floor():
		velocity.y += gravity*delta
		velocity.y = min(velocity.y, max_fall)
	elif jump:
		velocity.y = 0 - jump_strength
		jump = false
