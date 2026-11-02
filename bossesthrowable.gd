extends RigidBody2D
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(expire)
	timer.start()


func expire():
	queue_free()
