extends Control


func _ready() -> void:
	hide()


## Shows a note
## Takes a string as argument, that will be shown on the note. It supports BBCode.A bit
func show_note(note: String):
	%Text.text = note
	show()
	await $AnimationPlayer.play("open")


func hide_note():
	await $AnimationPlayer.play("close")


func _process(_delta):
	if Input.is_action_just_pressed("continue"):
		hide_note()
