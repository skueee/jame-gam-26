extends Area2D

@export var speed: float = 200.0

var attacking = false
var boss: CharacterBody2D
@onready var particles: CPUParticles2D = $CPUParticles2D


func _ready() -> void:
	boss = get_tree().get_first_node_in_group("anari")


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if not boss: return
		boss.death()
		particles.emitting = false
		$CollisionShape2D.disabled = true
