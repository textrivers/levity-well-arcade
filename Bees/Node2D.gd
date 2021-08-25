extends KinematicBody2D

var x_speed = 0
var y_speed = 0
var z_speed = 0
var speed_mod = 200

var target = Vector2(0, 0)
var diff = Vector2(0, 0)

var up_dir = Vector2(0, -1)

var right = true
var down = true
var zoom_in = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$XTimer.wait_time = 0.2
	$XTimer.start()
	$YTimer.wait_time = 0.2
	$YTimer.start()
	$ZTimer.wait_time = 0.2
	$YTimer.start()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	## update target and move_sign
	target = get_global_mouse_position()
	diff = position - target
	x_speed += delta * -diff.x
	#x_speed += delta * speed_mod * -sign(diff.x)
	if right && diff.x > 0:
		x_speed += delta * -diff.x
	if !right && diff.x < 0:
		x_speed += delta * -diff.x
	y_speed += delta * -diff.y
	if down && diff.y > 0:
		y_speed += delta * -diff.y
	if !down && diff.y < 0:
		y_speed += delta * -diff.y

	
# warning-ignore:return_value_discarded
	move_and_slide(Vector2(x_speed, y_speed), up_dir, false, 4, 0.5, false)

func _on_XTimer_timeout():
	if target.x > position.x:
		right = true
		$AnimatedSprite.flip_h = true
	else:
		right = false
		$AnimatedSprite.flip_h = false
	$XTimer.wait_time = rand_range(0, 1) + 1.5
	$XTimer.start()

func _on_YTimer_timeout():
	if target.y > position.y:
		down = true
	else:
		down = false
	$YTimer.wait_time = rand_range(0, 1) + 1.5
	$YTimer.start()

func _on_ZTimer_timeout():
	zoom_in = !zoom_in
	$ZTimer.wait_time = rand_range(0, 1) + 1.5
	$ZTimer.start()
