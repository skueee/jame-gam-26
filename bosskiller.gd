extends Area2D

@export var speed: float = 200.0

var attacking = false
var boss: CharacterBody2D

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

func _ready() -> void:
	boss = get_tree().get_first_node_in_group("boss")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		attacking = true
	elif body.name == "boss" and attacking:
		boss.unlockdeath()
		var mat: ParticleProcessMaterial = gpu_particles_2d.process_material
		mat.emission_sphere_radius = 50
func _physics_process(delta: float) -> void:
	boss = get_tree().get_first_node_in_group("boss")
	if not attacking or not is_instance_valid(boss):
		return
	var direction = (boss.global_position - global_position).normalized()
	global_position += direction * speed * delta
