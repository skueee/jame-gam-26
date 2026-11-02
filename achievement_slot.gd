@tool

extends HBoxContainer

@export var code = "anything"
@export var achieve := 100.0:
	set(value):
		achieve = value
		$ProgressBar.max_value = value
@export var achievement_name := "anything":
	set(value):
		achievement_name = value
		$Label.text = value


func _ready() -> void:
	$ProgressBar.max_value = achieve
	$Label.text = achievement_name

	if Engine.is_editor_hint():
		$ProgressBar.value = 10.0
		return

	$ProgressBar.value = Die.get(code)


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if $ProgressBar.value < $ProgressBar.max_value:
		$ProgressBar.value = Die.get(code)
	else:
		var orgstyle = $ProgressBar.get_theme_stylebox("fill") as StyleBoxTexture
		var new_style = orgstyle.duplicate()
		new_style.modulate_color = Color.GREEN
		$ProgressBar.add_theme_stylebox_override("fill", new_style)
