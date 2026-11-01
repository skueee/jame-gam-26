extends ProgressBar


@export var code = 'anything'
@export var achieve := 100

func _ready() -> void:
	max_value = achieve
	value = Die.get(code)

func _process(delta: float) -> void:
	
	if value < max_value:
		value = Die.get(code)
	else:
		var orgstyle = get_theme_stylebox("fill") as StyleBoxTexture
		var new_style = orgstyle.duplicate()
		new_style.modulate_color = Color.GREEN
		add_theme_stylebox_override("fill", new_style)
