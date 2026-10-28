extends CharacterBody2D
var direction = -1
var jumping = 0
@onready var left: RayCast2D = $left
@onready var right: RayCast2D = $right
var gravity = 780
var jump_velocity = 600
var speed = 150
@export var hpmax = 200
var hp = hpmax
var timer_but_cheap = 0
@export var thename = "Dronmar, the Killer Lord"
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var hud: Control = player.get_node("CanvasLayer/HUD")
@export var tilemap: TileMapLayer
func _ready() -> void:
	hud.add_custom_status(hp, hpmax, thename)
func set_movements(delta):
	if is_on_floor():
		jumping = true
	var notdirection = global_position.direction_to(player.global_position)
	if notdirection.x < 0:
		direction = -1
	else:
		direction = 1
	if abs(player.global_position.x - global_position.x) < 50:
		direction = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	set_movements(delta)
	if jumping and is_on_floor():
		velocity.y = jump_velocity * -1
		jumping = false
	if not is_on_floor():
		velocity.y += 980 * delta
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()
func forcejumpaway():
	pass
func die():
	if hp > 10:
		print("ouch")
		hp -= 10
		hud.add_custom_status(hp, hpmax, thename)
	else:
		tilemap.set_cell(Vector2i(2, -1), -1)
		tilemap.set_cell(Vector2i(2, 0), -1)
		tilemap.set_cell(Vector2i(2, 1), -1)
		tilemap.set_cell(Vector2i(2, 2), -1)
		queue_free()
		hud.hide()
