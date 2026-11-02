extends Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func toggle(state):
	visible = state
	collision_shape_2d.set_deferred("disabled", not state)


func _ready() -> void:
	Die.die.connect(_die)


func _die():
	print("toggle")
	toggle(true)



func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		Die.coins += 1
		Die.total_coins += 1
		print(collision_shape_2d.disabled)
		toggle(false)
