extends CPUParticles2D
@export_category("Torch Customisation")
@export var color_start: Color = "#ff0000"
@export var color_finish: Color = "ffff00"
@export var sparks_count: int = 4
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

func _ready():
	cpu_particles_2d.amount = sparks_count
	var custom = Gradient.new()
	custom.set_color(0, color_start)
	custom.set_color(1, color_finish)
	color_ramp = custom
