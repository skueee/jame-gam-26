extends Control


func _ready() -> void:
	hide()   # Hides when ready, because it needs to be initiated


## Shows a note
## [br]Takes a BBCode String as argument
func show_note(note: String):
	%Text.text = note
	show()
	$AnimationPlayer.play("open")
	await $AnimationPlayer.animation_finished

## Hides the note screen
func hide_note():
	$AnimationPlayer.play("close")
	await $AnimationPlayer.animation_finished
	hide()


func _process(_delta):
	if Input.is_action_just_pressed("continue"):
		hide_note()   # When clicking the button to close, close
