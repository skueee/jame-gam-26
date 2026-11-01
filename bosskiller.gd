extends Area2D

@export var speed: float = 200.0

var attacking = false
var boss: CharacterBody2D
var initial_dist: float
@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var hud: Control = get_node("/root/devil_5/player/CanvasLayer/HUD")
@onready var player: CharacterBody2D = get_node("/root/devil_5/player")

func _process(_float):
	var distance_y = position.y - player.position.y
	hud.add_custom_status(-distance_y, -initial_dist, "Anari")

func _ready() -> void:
	boss = get_tree().get_first_node_in_group("anari")
	initial_dist = position.y - player.position.y


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if not boss: return
		boss.death()
		particles.emitting = false
		$CollisionShape2D.disabled = true
