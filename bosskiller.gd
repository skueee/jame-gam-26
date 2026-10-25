extends Area2D
var attacking = false
var boss: CharacterBody2D
const SPEED = 100
func _ready() -> void:
	boss = get_tree().get_first_node_in_group("boss")
func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		attacking = true
		var direction = (boss.global_position - global_position).normalized()
		
func _physics_process(delta: float) -> void:
	if not attacking or not is_instance_valid(boss):
		return

	var direction = (boss.global_position - global_position).normalized()
	global_position += direction * SPEED * delta
