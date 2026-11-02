extends Node

enum SFX { UP, DOWN, OPEN, CLOSE }

var music: AudioStreamPlayer2D
var sfx_player: AudioStreamPlayer2D


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

	if scene.name in ["level_4", "level_5"] or scene.name.find("devil") != -1:
		packed = preload("res://cave.tscn")
	elif scene.name in ["level_6", "level_7"]:
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


## Plays an sfx
func sfx(sfx_name: SFX):
	var scene = get_tree().current_scene

	if not is_instance_valid(sfx_player):
		sfx_player = AudioStreamPlayer2D.new()
		scene.add_child(sfx_player)

	var stream: AudioStream = null

	match sfx_name:
		SFX.UP:
			stream = preload("res://assets/sfx/inariup.wav")
		SFX.DOWN:
			stream = preload("res://assets/sfx/inaridown.wav")
		SFX.OPEN:
			stream = preload("res://assets/sfx/inariopen.wav")
		SFX.CLOSE:
			stream = preload("res://assets/sfx/inariclose.wav")

	if stream:
		sfx_player.stream = stream
		sfx_player.play()
