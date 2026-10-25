extends Control

var selection := 0

func _ready() -> void:
	$AnimationPlayer.play("spawn")


func select(index: int):
	if index == 0:
		%PlayGradient.visible = true
		%SettingsGradient.visible = false
		%QuitGradient.visible = false
		
		%PlayGradient.size = Vector2(550.0,26.0)
		var tween = get_tree().create_tween()
		tween.tween_property(%PlayGradient, "size", Vector2(1152.0,26.0), 1.0)
		await tween.finished
		tween.kill()
	elif index == 1:
		%PlayGradient.visible = false
		%SettingsGradient.visible = true
		%QuitGradient.visible = false
		
		%SettingsGradient.size = Vector2(520.0,25.0)
		var tween = get_tree().create_tween()
		tween.tween_property(%SettingsGradient, "size", Vector2(1152.0,25.0), 1.0)
		await tween.finished
		tween.kill()
	elif index == 2:
		%PlayGradient.visible = false
		%SettingsGradient.visible = false
		%QuitGradient.visible = true
		
		%QuitGradient.size = Vector2(545.0,25.0)
		var tween = get_tree().create_tween()
		tween.tween_property(%QuitGradient, "size", Vector2(1152.0,25.0), 1.0)
		await tween.finished
		tween.kill()

func click(index: int):
	match index:
		0:
			get_tree().change_scene_to_file("res://main.tscn")
		2:
			get_tree().quit()

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
	elif Input.is_action_just_pressed("uiselect"):
		click(selection)
