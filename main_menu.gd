extends Control

var selection := 0


func _ready() -> void:
	$AnimationPlayer.play("spawn")


func select(index: int):
	%PlayGradient.visible = (index == 0)
	%QuitGradient.visible = (index == 1)

	match index:
		0:
			%PlayGradient.size = Vector2(550.0, 26.0)
			var tween = get_tree().create_tween()
			tween.tween_property(%PlayGradient, "size", Vector2(1152.0, 26.0), 1.0)
			await tween.finished
			tween.kill()
		1:
			%QuitGradient.size = Vector2(545.0, 25.0)
			var tween = get_tree().create_tween()
			tween.tween_property(%QuitGradient, "size", Vector2(1152.0, 25.0), 1.0)
			await tween.finished
			tween.kill()


func click(index: int):
	match index:
		0:
			get_tree().change_scene_to_file("res://main.tscn")
		1:
			get_tree().quit()


func navigate(direction: int):
	if selection + direction <= 1 and selection + direction >= 0:
		selection += direction
	elif selection + direction >= 1:
		selection = 0
	elif selection + direction <= 0:
		selection = 1


func _process(_delta):
	if Input.is_action_just_pressed("uidown"):
		navigate(1)
		select(selection)
	elif Input.is_action_just_pressed("uiup"):
		navigate(-1)
		select(selection)
	elif Input.is_action_just_pressed("uiselect"):
		click(selection)


func _on_play_area_mouse_entered() -> void:
	selection = 0
	select(selection)


func _on_quit_area_mouse_entered() -> void:
	selection = 1
	select(selection)


func _on_play_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		click(0)


func _on_quit_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		click(1)
