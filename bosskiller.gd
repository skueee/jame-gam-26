extends Area2D

var attacking = false
var boss: CharacterBody2D

@export var SPEED: float = 200.0

func _ready() -> void:
	boss = get_tree().get_first_node_in_group("boss")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		attacking = true
	elif body.name == "boss" and attacking:
		boss.unlockdeath()
		

func _physics_process(delta: float) -> void:
	boss = get_tree().get_first_node_in_group("boss")
	if not attacking or not is_instance_valid(boss):
		return
	var direction = (boss.global_position - global_position).normalized()
	global_position += direction * SPEED * delta
