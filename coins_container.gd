extends HBoxContainer

var coins = 0


func set_coins(value: int):
	var diff = abs(value - int($Label.text))
	$Label.text = str(value)
	for i in range(0, diff):
		$AnimatedSprite2D.play("spin")
		await $AnimatedSprite2D.animation_finished
