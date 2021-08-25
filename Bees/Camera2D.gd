extends Camera2D

var pos_target

func _ready():
	pos_target = position

func _process(delta):
	if Input.is_action_pressed("left"):
		pos_target.x -= 5
	if Input.is_action_pressed("right"):
		pos_target.x += 5
	pos_target.x = clamp(pos_target.x, -512, 512)
	
	if Input.is_action_pressed("up"):
		pos_target.y -= 5
	if Input.is_action_pressed("down"):
		pos_target.y += 5
	pos_target.y = clamp(pos_target.y, -264, 264)
	
	position = lerp(position, pos_target, 0.1)
