extends ProgressBar
## Handles everything related to the ProgressBar

@export var time_left: float = 0.0
var is_active: bool = false


func _ready():
	value = 0
	hide()


func _process(delta):
	if not is_active:
		return   # Quits if not active, because there is nothing to do

	# Updates time left with delta, and sets the value
	time_left -= delta
	value = time_left

	# Disable when no time is left
	if time_left <= 0 and is_active:
		is_active = false
		value = 0
		hide()

## Adds a status with a duration
## [br]The script will handle everything after that, and hide the bar after the duration
func add_status(duration: float, text: String = ""):
	max_value = duration
	time_left = duration
	value = duration
	is_active = duration
	$Label.text = text
	show()

## Sets a custom value on the bar
func add_custom(val: int, max: int, text: String = ""):
	max_value = max
	value = val
	is_active = false   # We do not want the bar to update itself, so it needs not to be active. is_active is only if the bar need to decrease with a duration
	$Label.text = text
	show()
