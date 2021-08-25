extends KinematicBody2D

var x_speed = 0
var y_speed = 0
var z_speed = 0
var speed_mod = 200

var target = Vector2(0, 0)
var hive = Vector2(0, 400)
var flower = Vector2(0, 0)
var diff = Vector2(0, 0)
var following = false
var pollinating = false
var depositing = false

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
	target = hive


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	## update target and move_sign
	if following:
		target = get_global_mouse_position()
	diff = position - target
	x_speed += delta * -diff.x
	if right && diff.x > 0:
		x_speed += delta * -diff.x *2
	if !right && diff.x < 0:
		x_speed += delta * -diff.x *2
	y_speed += delta * -diff.y
	if down && diff.y > 0:
		y_speed += delta * -diff.y * 2
	if !down && diff.y < 0:
		y_speed += delta * -diff.y *2
	
	if !following && abs(x_speed) < 5 && abs(y_speed) < 5 && abs(diff.x) < 5 && abs(diff.y) < 5:
		print(str(x_speed) + " | " + str(y_speed))
		x_speed = 0
		y_speed = 0
		if $PollenTimer.is_stopped():
			$PollenTimer.wait_time = 5.0
			$PollenTimer.start()
		if pollinating:
			$AnimatedSprite.stop()
		if depositing:
			$AnimatedSprite.hide()
	
# warning-ignore:return_value_discarded
	move_and_slide(Vector2(x_speed, y_speed), up_dir, false, 4, 0.5, false)
	
	## sizing
	scale = Vector2((position.y + 100) / 400, (position.y + 100) / 400)
	scale = scale / 2
	scale.x = clamp(scale.x, 0.1, 1.4)
	scale.y = clamp(scale.y, 0.1, 1.4)

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

func _on_Bee_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.button_index == 1:
		following = true

func _on_Bee_mouse_entered():
	$AnimatedSprite.modulate = Color(1, 0.5, 0.5)

func _on_Bee_mouse_exited():
	if !following:
		$AnimatedSprite.modulate = Color(1, 1, 1)

func _on_PollenTimer_timeout():
	pollinating = !pollinating
	depositing = !depositing
	if target == hive:
		$AnimatedSprite.show()
		target = flower
		if randi() % 5 == 0:
			get_parent().spawn_bee()
	elif target == flower:
		$AnimatedSprite.play()
		target = hive
	else:
		target = hive
		pollinating = false
		depositing = false
		following = false
		
