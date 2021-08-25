extends Area2D

var bull = preload("res://scenes/Bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_pressed("go_left"):
		position.x -= 5
	if Input.is_action_pressed("go_right"):
		position.x += 5
	position.x = clamp(position.x, -290, 290)
	
	if Input.is_action_just_pressed("fire"):
		fire_bullet()

func fire_bullet():
	var new_bull = bull.instance()
	new_bull.position.x = position.x
	new_bull.position.y = position.y - 20
	get_parent().add_child(new_bull)
	$LaserSound.play()
