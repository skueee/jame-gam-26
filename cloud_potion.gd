extends Area2D
@export var seconds: int = 20
@export var reusable: bool = false
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timey: Timer = $Timer


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.enable_bridge(seconds)
		Die.total_cloud_potions += 1
		if not reusable:
			queue_free()
		visible = false
		collision_shape_2d.set_deferred("disabled", true)
		timey.one_shot = true
		timey.wait_time = 10
		timey.timeout.connect(reappear)
		timey.start()


func reappear():
	visible = true
	collision_shape_2d.disabled = false
