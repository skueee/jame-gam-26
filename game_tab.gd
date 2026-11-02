extends CanvasLayer
@onready var button_3: Button = $Button3
@onready var button: Button = $Button

var scenes = [preload("res://Shop.tscn"), preload("res://achievements.tscn")]
var number = scenes.size()
var instance
var current_scene = 0


func _load_tab():
	if is_instance_valid(instance):
		instance.queue_free()
	instance = scenes[current_scene].instantiate()
	add_child(instance)


func _ready() -> void:
	action()


func _on_button_pressed() -> void:
	get_tree().get_first_node_in_group("player").menu = false
	get_tree().get_first_node_in_group("player").resumeshrinking()
	Die.menu_close.emit()
	queue_free()


func _on_button_presseds() -> void:
	current_scene += 1
	action()


func _on_button_3_pressed() -> void:
	current_scene -= 1
	action()


func action():
	if not button.disabled:
		if current_scene == number - 1:
			button.disabled = true
	else:
		if current_scene < number - 1:
			button.disabled = false
	if not button_3.disabled:
		if current_scene == 0:
			button_3.disabled = true
	else:
		if current_scene > 0:
			button_3.disabled = false
	_load_tab()
