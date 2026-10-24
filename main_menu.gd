extends Control

var selection := 0


func _ready() -> void:
	$AnimationPlayer.play("spawn")


func select(index: int):
	if index == 0:
		%PlayGradient.visible = true
		%SettingsGradient.visible = false
		%QuitGradient.visible = false
	elif index == 1:
		%PlayGradient.visible = false
		%SettingsGradient.visible = true
		%QuitGradient.visible = false
	elif index == 2:
		%PlayGradient.visible = false
		%SettingsGradient.visible = false
		%QuitGradient.visible = true


func navigate(direction: int):
	if selection + direction <= 2 and selection + direction >= 0:
		selection += direction
	elif selection + direction >= 2:
		selection = 0
	elif selection + direction <= 0:
		selection = 2


func _process(_delta):
	if Input.is_action_just_pressed("uidown"):
		navigate(1)
		select(selection)
	elif Input.is_action_just_pressed("uiup"):
		navigate(-1)
		select(selection)
