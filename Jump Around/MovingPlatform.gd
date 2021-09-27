extends KinematicBody2D

var pos_a: Vector2 = Vector2(0, 0)
var pos_b: Vector2 = Vector2(0, 0)
export var travel: Vector2 = Vector2(0, 0)
export var speed: float = 300.0
var tween
export var initial_delay: float
export var delay = 0.0
export var wrap = false
var follow: Vector2

func _ready():
	pos_a = global_position
	pos_b = global_position + travel
	follow = pos_a
	if initial_delay > 0.0:
		$Timer.wait_time = initial_delay
	else:
		$Timer.wait_time = 0.001
	$Timer.start()
	tween = $Tween
	var duration = pos_a.distance_to(pos_b) / float(speed)
	tween.interpolate_property(self, "global_position", pos_a, pos_b, duration, Tween.TRANS_LINEAR, Tween.EASE_IN, delay)
	if wrap == false:
		tween.interpolate_property(self, "global_position", pos_b, pos_a, duration, Tween.TRANS_LINEAR, Tween.EASE_IN, duration + (delay * 2))


func _on_Timer_timeout():
	tween.start()

#func _physics_process(_delta):
	#global_position = global_position.linear_interpolate(follow, 0.15)

