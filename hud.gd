extends Control


## Adds a status to the StatusBar that will finish after a certain duration
##
##[br][br][param duration]: The duration of the status. The bar will hide after that.
##[br][param text]: The text shown at the top of the progressbar, usually a little thing to help the player know what is happening (Optional).
func add_duration_status(duration: float, text: String = ""):
	$StatusBar.add_status(duration, text)


## Add a custom value on the bar.
##
##[br][br][param status]: The value of the progressbar.
##[br][param max]: The maximum value of the progressbar.
##[br][param text]: The text shown at the top of the progressbar (Optional).
func add_custom_status(status: int, max: int, text: String = ""):
	$StatusBar.add_custom(status, max, text)


## Changes the number of hearths shown on screen
func change_health(health):
	$HeartsContainer.set_lives(health)
