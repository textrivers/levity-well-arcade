extends StaticBody2D

func _process(delta):
	if $Timer.is_stopped():
		$Sprite.modulate.a = 0
	else:
		$Sprite.modulate.a = $Timer.time_left

func ghost_protocol():
	$Timer.wait_time = 1.0
	$Timer.start()
	set_collision_layer(3)

func _on_Area2D_body_entered(body):
	if body.is_in_group("squirrel"):
		ghost_protocol()


func _on_Area2D_body_exited(body):
	if body.is_in_group("squirrel"):
		set_collision_layer(2)
