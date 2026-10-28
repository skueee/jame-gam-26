extends Control
## Script that shows the dialogue UI and handles the dialogue logic
##
## It will:
##         - show the dialogue box
##         - listen to inputs
##         - hide the box when finished


signal dialogue_finished

var dialog_active: bool = false
var current_text: Array
var next_text_index: int

@onready var _speaker: Label = $DialogueBox/Speaker
@onready var _speaker_sprite: TextureRect = $DialogueBox/SpeakerSprite
@onready var _dialogue: RichTextLabel = $DialogueBox/Text
@onready var _box: NinePatchRect = $DialogueBox

## Displays the DialogBox with lines in an array and an optional speaker, sprite and border color
##
## [br][br]Example:
## [code]display_text(["Never gonna give you up","Never gonne let you down"],"Rick Astley",load("res://icon.svg"),Color("ffffffff"))[/code]
## 
## [br][br][param lines]: An array with the lines that will be spoken by the character.
## [br][param speaker]: The speaker's name (optional).
## [br][param speaker_sprite]: The speaker's sprite (optional).
## [br][param color]: The color of the border of the DialogBox (optional, defaults to black)
func display_text(
	lines: Array,
	speaker: String = "",
	speaker_sprite: Texture2D = null,
	color: Color = Color("black")
):
	show_text_box(speaker, speaker_sprite, color)
	current_text = lines
	display_line(current_text[0])
	next_text_index = 1


## Function to display a line on the dialogue label
func display_line(line: String):
	_dialogue.text = line


## Shows the dialoguebox and assigns everything
func show_text_box(
	speaker: String = "", speaker_sprite: Texture2D = null, color: Color = Color("black")
):
	get_tree().get_first_node_in_group("player").pauseshrinking()
	dialog_active = true
	visible = true
	_speaker.visible = (speaker != "")
	_speaker.text = speaker
	if speaker_sprite != null:
		_speaker_sprite.visible = true
		_speaker_sprite.texture = speaker_sprite
	else:
		_speaker_sprite.visible = false
	_box.material.set_shader_parameter("replacement_color", color)


## Hides the dialoguebox
func hide_text_box():
	dialog_active = false
	visible = false
	dialogue_finished.emit()
	get_tree().get_first_node_in_group("player").resumeshrinking()


## Ensure that the dialogue is not finished, then show the next line
func go_to_next_text():
	if next_text_index < current_text.size():
		display_line(current_text[next_text_index])
		next_text_index += 1
	else:
		hide_text_box()


## Handles input
func _process(_delta: float) -> void:
	if dialog_active and Input.is_action_just_pressed("continue"):
		go_to_next_text()
