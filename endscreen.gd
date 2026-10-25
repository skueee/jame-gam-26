extends Control

var selection: int = 0

func _ready() -> void:
	$AnimationPlayer.play("open")
	await $AnimationPlayer.animation_finished

func click(index: int):
	match index:
		0:
			get_tree().change_scene_to_file("res://main_menu.tscn")
		1:
			get_tree().quit()

func select(index: int):
		%TitleGradient.visible = (index == 0)
		%QuitGradient.visible = (index == 1)

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


func _on_title_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		click(0)



func _on_quit_area_mouse_entered() -> void:
	selection = 1
	select(selection)


func _on_quit_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		click(1)
