extends Area2D
@export var level: int = 2
@export var end: bool = false
@export var devil: bool = false



func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		var path: String
		if end:
			path = "res://endscreen.tscn"
		elif devil:
			path = "res://devil_" + str(level) + ".tscn"
		else:
			path = "res://level_" + str(level) + ".tscn"
		Die.total_times_telported += 1
		get_tree().call_deferred("change_scene_to_file", path)
