extends RigidBody2D
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(expire)
	timer.start()


func expire():
	freeze = false
	apply_central_impulse(Vector2(0, -0.2))
	timer.timeout.connect(expire2)
	timer.start()

func expire2():
	queue_free()
