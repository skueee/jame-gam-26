extends Area2D

@export var id := "anything"
@export var time := 1
@export var target : Vector2

var cooldown := false
var positionstart : Vector2

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.timeout.connect(done)
	positionstart = global_position


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if body._collected(id):
			var tween = create_tween()
			tween.tween_property(self, "global_position", target, time)
			await tween.finished
			timer.start()


func done():
	var tween = create_tween()
	tween.tween_property(self, "position", positionstart, time)
