extends Light2D

var pos_a: Vector2
var pos_b: Vector2

func _ready():
	pos_a = global_position
	pos_b = Vector2(-global_position.x, global_position.y)

func _on_Timer_timeout():
	$Timer.wait_time = 4.0
	$Timer.start()
	$Tween.interpolate_property(self, "global_position", pos_a, pos_b, 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
