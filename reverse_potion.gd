extends Area2D

@export var seconds := 15


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.reverseshrinking(seconds)
		Die.total_reverse_shrink_potions += 1
		queue_free()
