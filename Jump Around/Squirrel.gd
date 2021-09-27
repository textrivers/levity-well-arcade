extends KinematicBody2D

var velocity = Vector2()
var mouse_pos = Vector2()
var dir = Vector2()
var jump_speed = 800
var gravity = 1800
var up = Vector2()
var snap: Vector2
var down = Vector2()
var flying = true
var stop_slope_threshold = 64.0
var right = 1
var stand = preload("res://assets/images/squirrel_stand.png")
var jump1 = preload("res://assets/images/squirrel_jump1.png")
var jump2 = preload("res://assets/images/squirrel_jump2.png")
var butt

signal jump
signal land

func _ready():
	up = Vector2(0, -1)
	down = Vector2(0, 1)
	butt = $Sprite/Butt
# warning-ignore:return_value_discarded
	self.connect("jump", get_node("/root/Room/UI"), "on_squirrel_jump")

func _physics_process(delta):
	mouse_pos = get_global_mouse_position()
	
	if flying: 
		snap = Vector2(0, 0)
		velocity.y += gravity * delta
		rotation += right * 0.05
	else:
		snap = down * 32
		velocity = Vector2(0, 0)
		if Input.is_action_just_pressed("jump"):
			emit_signal("jump")
			flying = true
			snap = Vector2(0, 0)
			$Sprite.texture = jump1
			dir = mouse_pos - position
			if dir.x > 0:
				right = 1
			else: 
				right = -1
			dir = dir.normalized()
			up = Vector2(0, -1)
			rotation = get_angle_to(mouse_pos) + rotation
			if right == -1:
				rotation += PI
			velocity = dir * jump_speed
	
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, false, 1, PI / 2, false)
	
	$Sprite.scale.x = right
	
	## collision
	if get_slide_count() > 0 && flying == true:
		var collision = get_slide_collision(get_slide_count() - 1)
		## orientation
		var ang = collision.normal.angle()
		if sin(ang) <= 0.01:
			emit_signal("land")
			$Sprite.texture = stand
			flying = false
			velocity = Vector2(0, 0)
			up = collision.normal
			down = -up 
			## rotation
			rotation = up.angle() + deg2rad(90)
		else: 
			flying = true
	
	if flying == false && !$RayCast2D.is_colliding():
			flying = true
