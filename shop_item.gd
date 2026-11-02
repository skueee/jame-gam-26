@tool

extends HBoxContainer

@export var namei := "Speed Booster":
	set(value):
		namei = value
		if is_node_ready():
			update(value, cost)
@export var cost := 2:
	set(value):
		cost = value
		if is_node_ready():
			update(namei, cost)
@export var code := "speed_booster"

@onready var label: Label = $Label
@onready var label_2: Label = $Label2
@onready var button: Button = $Button


func update(item_name: String, item_cost: int):
	label.text = str(item_cost) + "X"
	label_2.text = item_name


func _ready() -> void:
	update(namei, cost)


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if Die.coins < cost:
		button.disabled = true
	else:
		button.disabled = false


func _on_button_pressed() -> void:
	if Engine.is_editor_hint():
		return

	Die.coins -= cost
	Die.emit_signal(code)
