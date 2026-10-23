extends Area2D
@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.timeout.connect(done)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.shrink_percent = 0

func done():
	pass
