extends Area2D
@export var id := "anything"
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D


func _process(_delta: float) -> void:
	var nodes = get_tree().get_nodes_in_group("player")
	if nodes.size() > 0:
		nodes = nodes[0]
		if not nodes.collected.has(id):
			toggle(true)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.collected.append(id)
		Die.total_keys_collected += 1
		toggle(false)


func toggle(state):
	visible = state
	collision_shape_2d.set_deferred("disabled", not state)
