# Dialogue logic
# To use, call displayText() with your lines in an array, the speaker, the speaker sprite (a Texture2D)
# For ex: displayText(["Never gonna give you up","Never gonne let you down"],"Rick Astley",load("res://icon.svg"))
#                      The two lines that will be displayed                   Character     Sprite

extends Control

signal dialogue_finished

var dialog_active : bool = false
var current_text : Array
var next_text_index : int

@onready var _speaker : Label = $Speaker
@onready var _speaker_sprite : TextureRect = $SpeakerSprite
@onready var _dialogue : RichTextLabel = $Text

# Main function to call, it display text and then hides the textbox
func displayText(lines : Array, speaker : String = "", speaker_sprite : Texture2D = null):
	showTextBox(speaker, speaker_sprite)
	current_text = lines
	displayLine(current_text[0])
	next_text_index = 1

# Just displays a line on the Text label
func displayLine(line : String):
	_dialogue.text = line

# Shows the dialogue and assigns everything
func showTextBox(speaker : String = "", speaker_sprite : Texture2D = null):
	dialog_active = true
	visible = true
	_speaker.visible = (speaker != "")
	_speaker.text = speaker
	if speaker_sprite != null:
		_speaker_sprite.visible = true
		_speaker_sprite.texture = speaker_sprite
	else:
		_speaker_sprite.visible = false
		
# Hides the dialogue
func hideTextBox():
	dialog_active = false
	visible = false
	dialogue_finished.emit()

# Ensure that the dialogue is not finished, then show the next line
func goToNextText():
	if next_text_index < current_text.size():
		displayLine(current_text[next_text_index])
		next_text_index += 1
	else:
		hideTextBox()

# Just checks if there is input
func _process(_delta: float) -> void:
	if dialog_active and Input.is_action_just_pressed("interact"):
		goToNextText()
