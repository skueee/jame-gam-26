extends HBoxContainer

@export var hearth: Texture2D = load("res://icon.svg")
@export var default_count: int = 2
@export var sprite_size: Vector2 = Vector2(64,64)

func _ready():
	set_lives(default_count)

func set_lives(count: int) -> void:
	for child in get_children():
		child.queue_free()

	for i in range(count):
		var texture_rect = TextureRect.new()
		texture_rect.texture = hearth
		texture_rect.expand_mode = TextureRect.EXPAND_FIT_HEIGHT

		texture_rect.custom_minimum_size = sprite_size
		texture_rect.custom_maximum_size = sprite_size

		add_child(texture_rect)
