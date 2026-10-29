extends CharacterBody2D
# this will be the most complex ai byfar (foreshadowing?)
@export var ultimate_target: CharacterBody2D
@export var max_speed: int = 400
@export var acceleration: int = 300
@export var slowingss: int = 8000
@export var livetime: int = 15
@export var tilemap: TileMapLayer
var timer = 0
var timer2 = 0
var timer3 = 0
var state = "idle"
var states = ["idle", "chasing", "decaying"]
var lastidle = -1
var idlefarness = 20
var target_pos = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not ultimate_target:
		ultimate_target = get_tree().get_first_node_in_group("player")




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if timer < livetime:
		timer += delta
	else:
		state = "decaying"
	var directionx = 0
	var directiony = 0
	var direction_to_go = Vector2(0,0)
	if state == "idle":
		if global_position.distance_to(ultimate_target.global_position) < 100:
			state = "chasing"
	elif state == "chasing":
		direction_to_go = global_position.direction_to(ultimate_target.global_position)
		directionx = direction_to_go.x
		directiony = direction_to_go.y
	elif state == "decaying":
		if timer2 < 5:
			timer2 += delta
		else:
			var soul = $soultrail.duplicate()
			get_parent().add_child(soul)
			soul.flyup()
			soul.global_position = global_position
			if not tilemap:
				queue_free()
				return
			tilemap.set_cell(Vector2i(2, -1), -1)
			tilemap.set_cell(Vector2i(2, 0), -1)
			tilemap.set_cell(Vector2i(2, 1), -1)
			tilemap.set_cell(Vector2i(2, 2), -1)
			queue_free()
	if directionx:
			velocity.x = move_toward(velocity.x, directionx * max_speed, delta * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, slowingss * delta)
	if directiony:
			velocity.y = move_toward(velocity.y, directiony * max_speed, delta * acceleration)
	else:
		velocity.y = move_toward(velocity.y, 0, slowingss * delta)
	move_and_slide()
