extends Area2D


func _on_body_entered(body):
	if not body.name.find("enemy") == -1:
		body.queue_free()
	elif body.name.find("boss") != -1:
		body.die()
	if body.name == "miniboss":
		get_parent().queue_free()
