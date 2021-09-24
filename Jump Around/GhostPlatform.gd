extends StaticBody2D



func _process(delta):
	$Sprite.modulate.a = 1 - $Timer.time_left

func ghost_protocol():
	$Timer.wait_time = 1.0
	$Timer.start()


func _on_Area2D_body_entered(body):
	if body.is_in_group("squirrel"):
		ghost_protocol()
