# Dialogue logic
# To use, call display_text() with your lines in an array, the speaker, the speaker sprite (a Texture2D)
# For ex: display_text(["Never gonna give you up","Never gonne let you down"],"Rick Astley",load("res://icon.svg"),Color("ffffffff"))
#                      The two lines that will be displayed                   Character     Sprite                 Color
# Color, Character and Sprite are optional

extends Control

signal dialogue_finished

var dialog_active: bool = false
var current_text: Array
var next_text_index: int

@onready var _speaker: Label = $DialogueBox/Speaker
@onready var _speaker_sprite: TextureRect = $DialogueBox/SpeakerSprite
@onready var _dialogue: RichTextLabel = $DialogueBox/Text
@onready var _box: NinePatchRect = $DialogueBox


# Main function to call, it display text and then hides the textbox
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


# Just displays a line on the Text label
func display_line(line: String):
	_dialogue.text = line


# Shows the dialogue and assigns everything
func show_text_box(
	speaker: String = "", speaker_sprite: Texture2D = null, color: Color = Color("black")
):
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


# Hides the dialogue
func hide_text_box():
	dialog_active = false
	visible = false
	dialogue_finished.emit()


# Ensure that the dialogue is not finished, then show the next line
func go_to_next_text():
	if next_text_index < current_text.size():
		display_line(current_text[next_text_index])
		next_text_index += 1
	else:
		hide_text_box()


# Just checks if there is input
func _process(_delta: float) -> void:
	if dialog_active and Input.is_action_just_pressed("continue"):
		go_to_next_text()
