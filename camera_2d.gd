extends Camera2D

@export var shaketime = 5
@export var shaketensivity = 50
@export var short = 0.5

var timer = 0
var shaking = false
var pos: Vector2 = Vector2(0,0)

func shake(isshort = false):
	shaking = true
	if isshort:
		shaketime = short


func _ready() -> void:
	pos = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shaking:
		if timer < shaketime:
			timer += delta
			position.y = pos.y + randi_range(-1*shaketensivity, shaketensivity)
			position.x = pos.x + randi_range(-1*shaketensivity, shaketensivity)
		else:
			timer = 0
			shaking = false
			position = pos
