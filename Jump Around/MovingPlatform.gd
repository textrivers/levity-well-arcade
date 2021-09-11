extends KinematicBody2D

var pos_a: Vector2 = Vector2(0, 0)
var pos_b: Vector2 = Vector2(0, 0)
export var travel: Vector2 = Vector2(0, 0)
export var speed: float = 300.0
var tween
export var delay = 0.0
export var wrap = false

func _ready():
	pos_a = global_position
	pos_b = global_position + travel
	tween = $Tween
	var duration = pos_a.distance_to(pos_b) / float(speed)
	tween.interpolate_property(self, "position", pos_a, pos_b, duration, Tween.TRANS_LINEAR, Tween.EASE_IN, delay)
	if wrap == false:
		tween.interpolate_property(self, "position", pos_b, pos_a, duration, Tween.TRANS_LINEAR, Tween.EASE_IN, duration + (delay * 2))
	tween.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
