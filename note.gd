extends Control


func _ready() -> void:
	hide()


## Shows a note
## Takes a string as argument, that will be shown on the note. It supports BBCode.A bit
func show_note(note: String):
	%Text.text = note
	show()
	$AnimationPlayer.play("open")
	await $AnimationPlayer.animation_finished


func hide_note():
	$AnimationPlayer.play("close")
	await $AnimationPlayer.animation_finished
	hide()


func _process(_delta):
	if Input.is_action_just_pressed("continue"):
		hide_note()
