extends StaticBody2D
## Script for the note sprites
## It needs a note.gd node in the note_ui group to work

## The text that will be shown on the notes.
## [br][br]It supports BBCode ! [br][url]https://docs.godotengine.org/en/latest/tutorials/ui/bbcode_in_richtextlabel.html[/url]
@export_multiline var note: String = "Lorem Ipsum"

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var note_screen: Control = get_tree().get_first_node_in_group("note_ui")


func _process(_delta: float) -> void:
	if not player:
		return
	var player_pos = player.global_position
	var distance = global_position.distance_to(player_pos)
	if distance < 28:
		$e.visible = true
		if Input.is_action_just_pressed("interact"):
			note_screen.show_note(note)
	else:
		$e.visible = false
