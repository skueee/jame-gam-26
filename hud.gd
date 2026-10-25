extends Control


## Adds a status to the StatusBar that will finish after a certain duration
## Text can be an hint that will tell the player whats happening and what they can do, for example "Press shift to bridge", but is optional
func add_duration_status(duration: float, text: String = ""):
	$StatusBar.add_status(duration, text)

## Add a custom value on the bar
func add_custom_status(status: int, max: int, text: String = ""):
	$StatusBar.add_custom(status, max, text)

## Changes the number of hearths shown on screen
func change_health(health):
	$HeartsContainer.set_lives(health)
