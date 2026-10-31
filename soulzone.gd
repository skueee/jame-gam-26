extends Area2D
@onready var soultrail: CPUParticles2D = $"../soultrail"


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.add_child(soultrail.duplicate())
		body.die()
		get_parent().hit = true
