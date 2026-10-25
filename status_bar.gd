extends ProgressBar

@export var time_left: float = 0.0
var is_active: bool = false

func _ready():
	value = 0
	hide()
	
func _process(delta):
	if not is_active:
		return
	
	time_left -= delta
	value = time_left
	
	if time_left <= 0:
		is_active = false
		value = 0
		hide()
		
func add_status(duration: float, text: String = ""):
	max_value = duration
	time_left = duration
	value = duration
	is_active = duration
	$Label.text = text
	show()
