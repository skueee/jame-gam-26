extends CharacterBody2D

@export var secondary = false
@export var thename = "Spikynox, Apostle of Destructions"
@export var tilemap: TileMapLayer

var direction = -1
var jumping = 0
var gravity = 780
var jump_velocity = 450
var speed = 300
var hp = 150
var timer_but_cheap = 0

@onready var left: RayCast2D = $left
@onready var right: RayCast2D = $right
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var hud: Control = player.get_node("CanvasLayer/HUD")


func _ready() -> void:
	hud.add_custom_status(hp, 150, thename)

func set_movements(delta):
	if is_on_floor():
		if timer_but_cheap < 0.2:
			timer_but_cheap += delta
		else:
			timer_but_cheap = 0
			jumping = true
	if right.get_collider():
		if right.get_collider().name != "player":
			direction = -1
	elif left.get_collider():
		if left.get_collider().name != "player":
			direction = 1

func forcejumpaway():
	direction *= -1
	velocity.y = jump_velocity * -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	set_movements(delta)
	$Sprite2D.rotation_degrees += direction * 660*delta
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

func die():
	if hp > 10:
		hp -= 10
		hud.add_custom_status(hp, 150, thename)
	else:
		if secondary:
			queue_free()
			return
		tilemap.set_cell(Vector2i(2, -1), -1)
		tilemap.set_cell(Vector2i(2, 0), -1)
		tilemap.set_cell(Vector2i(2, 1), -1)
		tilemap.set_cell(Vector2i(2, 2), -1)
		queue_free()
		hud.hide()
