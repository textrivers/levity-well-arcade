extends KinematicBody2D

var velocity = Vector2()
var mouse_pos = Vector2()
var dir = Vector2()
var jump_speed = 800
var gravity = 1500
var up = Vector2()
var down = Vector2()
var flying = false
var right = 1
var stand = preload("res://assets/images/squirrel_stand.png")
var jump1 = preload("res://assets/images/squirrel_jump1.png")
var jump2 = preload("res://assets/images/squirrel_jump2.png")
var butt

func _ready():
	up = Vector2(0, -1)
	down = Vector2(0, 1)
	butt = $Sprite/Butt

func _physics_process(delta):
	mouse_pos = get_global_mouse_position()
	
	if Input.is_action_just_pressed("jump") && flying == false:
		flying = true
		dir = mouse_pos - position
		if dir.x > 0:
			right = 1
		else: 
			right = -1
		dir = dir.normalized()
		up = Vector2(0, -1)
		rotation = get_angle_to(mouse_pos) + rotation
		if right == -1:
			rotation += 60
		velocity = dir * jump_speed
	
	if flying:
		velocity.y += gravity * delta
		$Sprite.texture = jump1
		rotation += right * 0.05
	velocity = move_and_slide(velocity, up, false, 4, 0.8, false)
	
	$Sprite.scale.x = right
	
	## collision
	if get_slide_count() > 0 && flying == true:
		var collision = get_slide_collision(get_slide_count() - 1)
		print(get_slide_count())
		$Sprite.texture = stand
		flying = false
		velocity = Vector2(0, 0)
		up = collision.normal
		down = -up 
		## rotation
		rotation = up.angle() + deg2rad(90)

