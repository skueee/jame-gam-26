extends HBoxContainer

var coins = 0


# Sets coins to the actual number when launching the scene !
func _ready():
	set_coins(Die.coins, false)


func set_coins(value: int, animation: bool = true):
	var diff = abs(value - int($Label.text))
	$Label.text = str(value)
	if animation:
		for i in range(0, diff):
			$AnimatedSprite2D.play("spin")
			await $AnimatedSprite2D.animation_finished
