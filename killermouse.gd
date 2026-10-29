extends CharacterBody2D

@onready var right: RayCast2D = $right
@onready var left: RayCast2D = $left
var speed = 300
var direction = -1

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += 980 * delta
		move_and_slide()
		return
	var leftcol = left.get_collider()
	if leftcol:
		if leftcol.name == "TileMapLayer2":
			direction = 1
	var rightcol = right.get_collider()
	if rightcol:
		if rightcol.name == "TileMapLayer2":
			direction = -1
	velocity.x = speed * direction
	$Sprite2D.flip_h = false if direction <0 else true
	move_and_slide()
