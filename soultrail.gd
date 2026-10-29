extends CPUParticles2D
var flyingup = false
var timr = 0
func flyup():
	flyingup = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not flyingup: return
	global_position.y += -20 * delta
	if timr < 5:
		timr += delta
	else:
		queue_free()
