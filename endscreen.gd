extends Control

## The current selection. 0 is the element the most at the top. 
var selection: int = 0


func _ready() -> void:
	$AnimationPlayer.play("open")
	await $AnimationPlayer.animation_finished


func click(index: int):
	match index:
		0:  # Return to title button
			get_tree().change_scene_to_file("res://main_menu.tscn")
		1:  # Quit button
			get_tree().quit()


## Changes the visibility of the gradient depending on the selection
func select(index: int):
	%TitleGradient.visible = (index == 0)
	%QuitGradient.visible = (index == 1)


## Sets the right index number
## This is ass code
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


func _on_title_area_mouse_entered() -> void:
	selection = 0
	select(selection)


func _on_title_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		click(0)


func _on_quit_area_mouse_entered() -> void:
	selection = 1
	select(selection)


func _on_quit_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		click(1)
