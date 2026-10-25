extends Node

var music: AudioStreamPlayer2D

func _ready() -> void:
	get_tree().scene_changed.connect(_on_scene_changed)

	if get_tree().current_scene:
		_on_scene_changed()


func _on_scene_changed() -> void:
	var scene = get_tree().current_scene
	if not scene:
		return

	if is_instance_valid(music):
		music.queue_free()

	var packed: PackedScene

	if scene.name == "level_4":
		packed = preload("res://cave.tscn")
	elif scene.name == "level_5":
		packed = preload("res://boss_music.tscn")
	else:
		packed = preload("res://forest.tscn")

	music = packed.instantiate()
	scene.add_child(music)

	music.finished.connect(restart)
	music.play()


func restart() -> void:
	if is_instance_valid(music):
		music.play()
