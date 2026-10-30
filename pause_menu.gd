extends Control

## The current selection. 0 is the element the most at the top. 
var selection := 0

var active: bool = false

var shop = preload('res://Shop.tscn')

func _ready() -> void:
	hide() # We don't want it to trigger at startup

## Opens the pause menu
func open():
	get_tree().get_first_node_in_group("player").pauseshrinking()
	show()
	$AnimationPlayer.play("open")
	await $AnimationPlayer.animation_finished
	active = true
	Engine.time_scale = 0

## Closes the pause menu
func close():
	Engine.time_scale = 1
	active = false
	$AnimationPlayer.play("close")
	await $AnimationPlayer.animation_finished
	Die.pause_close.emit()
	hide()
	get_tree().get_first_node_in_group("player").resumeshrinking()

func select(index: int):
	# Sets the visibility of the gradients depending on the selection
	%ContinueGradient.visible = (index == 0)
	%TitleGradient.visible = (index == 1)
	%QuitGradient.visible = (index == 2)

	# Plays the animation
	match index:
		0:
			%ContinueGradient.size = Vector2(550.0, 20.0)
			var tween = get_tree().create_tween()
			tween.tween_property(%ContinueGradient, "size", Vector2(1152.0, 20.0), 1.0)
			await tween.finished
			tween.kill()
		1:
			%TitleGradient.size = Vector2(545.0, 20.0)
			var tween = get_tree().create_tween()
			tween.tween_property(%TitleGradient, "size", Vector2(1152.0, 20.0), 1.0)
			await tween.finished
			tween.kill()
		2:
			%QuitGradient.size = Vector2(545.0, 20.0)
			var tween = get_tree().create_tween()
			tween.tween_property(%QuitGradient, "size", Vector2(1152.0, 20.0), 1.0)
			await tween.finished
			tween.kill()

func click(index: int):
	match index:
		0:  # Continue button
			close()
		1:  # Title button
			get_tree().change_scene_to_file("res://main_menu.tscn")
		2:  # Quit button
			get_tree().quit()

## Sets the right index number
## This is ass code
func navigate(direction: int):
	if selection + direction <= 2 and selection + direction >= 0:
		selection += direction
	elif selection + direction >= 2:
		selection = 0
	elif selection + direction <= 0:
		selection = 2
		
func _process(_delta):
	if Input.is_action_just_pressed("uidown") and active:
		navigate(1)
		select(selection)
	elif Input.is_action_just_pressed("uiup") and active:
		navigate(-1)
		select(selection)
	elif Input.is_action_just_pressed("uiselect") and active:
		click(selection)


func _on_continue_area_mouse_entered() -> void:
	if active:
		selection = 0
		select(selection)


func _on_title_area_mouse_entered() -> void:
	if active:
		selection = 1
		select(selection)


func _on_quit_area_mouse_entered() -> void:
	if active:
		selection = 2
		select(selection)


func _on_continue_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if active and event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		click(0)


func _on_title_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if active and event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		click(1)


func _on_quit_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if active and event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		click(2)
