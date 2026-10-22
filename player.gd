extends CharacterBody2D

# just some code to make player move
const SPEED = 300.0


func _physics_process(delta: float) -> void:
	var leftright := Input.get_axis("left", "right")
	if leftright:
		velocity.x = leftright * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	var updown := Input.get_axis("up", "down")
	if updown:
		velocity.y = updown * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
