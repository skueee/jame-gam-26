extends Control

var selection := 0   ## The current selection. 0 is the element the most at the top.
var active: bool = false

@onready var tween: Tween


func _ready() -> void:
	hide() # We don't want it to trigger at startup

## Opens the pause menu
func open():
	Music.sfx(Music.SFX.OPEN)
	get_tree().get_first_node_in_group("player").pauseshrinking()
	get_tree().get_first_node_in_group("player").menu = true
	show()
	$AnimationPlayer.play("open")
	await $AnimationPlayer.animation_finished
	active = true
	Engine.time_scale = 0.000001

## Closes the pause menu
func close(stop_menu: bool = true):
	Music.sfx(Music.SFX.CLOSE)
	Engine.time_scale = 1
	active = false
	$AnimationPlayer.play("close")
	await $AnimationPlayer.animation_finished
	hide()
	get_tree().get_first_node_in_group("player").resumeshrinking()
	get_tree().get_first_node_in_group("player").menu = !stop_menu

func select(index: int):
	# Sets the visibility of the gradients depending on the selection
	%ContinueGradient.visible = (index == 0)
	%MenuGradient.visible = (index == 1)
	%TitleGradient.visible = (index == 2)
	%QuitGradient.visible = (index == 3)
	
	if tween and tween.is_valid():
		tween.kill()
	
	tween = create_tween()

	# Plays the animation
	match index:
		0:
			%ContinueGradient.size = Vector2(528.0, 20.0)
			tween.tween_property(%ContinueGradient, "size", Vector2(1152.0, 20.0), 1.0 * Engine.time_scale)
		1:
			%MenuGradient.size = Vector2(546.0, 20.0)
			tween.tween_property(%MenuGradient, "size", Vector2(1152.0, 20.0), 1.0 * Engine.time_scale)
		2:
			%TitleGradient.size = Vector2(510.0, 20.0)
			tween.tween_property(%TitleGradient, "size", Vector2(1152.0, 20.0), 1.0 * Engine.time_scale)
		3:
			%QuitGradient.size = Vector2(552.0, 20.0)
			tween.tween_property(%QuitGradient, "size", Vector2(1152.0, 20.0), 1.0 * Engine.time_scale)

func click(index: int):
	Music.sfx(Music.SFX.OPEN)
	match index:
		0:  # Continue button
			close()
		1:  # Menu button
			close(false)
			get_tree().get_first_node_in_group("players").open_menu()
		2:  # Title button
			get_tree().change_scene_to_file("res://main_menu.tscn")
		3:  # Quit button
			get_tree().quit()

## Sets the right index number
## This is ass code
func navigate(direction: int):
	if selection + direction <= 3 and selection + direction >= 0:
		selection += direction
	elif selection + direction >= 3:
		selection = 0
	elif selection + direction <= 0:
		selection = 3
	
	if direction < 0:
		Music.sfx(Music.SFX.DOWN)
	elif direction > 0:
		Music.sfx(Music.SFX.UP)

func _process(_delta):
	if Input.is_action_just_pressed("uidown") and active:
		navigate(1)
		select(selection)
	elif Input.is_action_just_pressed("uiup") and active:
		navigate(-1)
		select(selection)
	elif Input.is_action_just_pressed("uiselect") and active:
		click(selection)

# ALL OF THE CODE AFTER THIS DOES NOT WORK AND IS NOT UPDATED WITH LATEST THINGS
# I don't think it's necessary
# - skue
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
