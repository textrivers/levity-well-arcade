extends KinematicBody2D

var gravity = 1400
var dir: Vector2 = Vector2(0, 0)
var accel = 20
var velocity: Vector2 = Vector2(0, 0)
var airborn: bool = true
var facing_right: bool = true
var walking: bool = false
var snap: Vector2 = Vector2.ZERO
var butt

# Called when the node enters the scene tree for the first time.
func _ready():
	butt = $AnimatedSprite/Butt

func _physics_process(delta):
	## POOP =============================================
	if Input.is_action_pressed("rightclick"):
		var new_ball = preload("res://SmallBall.tscn").instance()
		new_ball.global_position = butt.global_position
		new_ball.global_position.x += float(randi() % 3)
		new_ball.rotation += randf()
		get_parent().add_child(new_ball)
	dir = Vector2(0, 0)
	if Input.is_action_pressed("move_left"):
		dir += Vector2.LEFT
	if Input.is_action_pressed("move_right"):
		dir += Vector2.RIGHT
	if !$RayCast2D.is_colliding() && airborn == false:
		airborn = true
	if airborn:
		velocity.y += gravity * delta
	else:
		if walking == false:
			if dir.x != 0:
				walking = true
				$AnimatedSprite.play("walk")
		if dir.x == 0:
			walking = false
			$AnimatedSprite.stop()
			$AnimatedSprite.set_frame(0)
			velocity.x = 0
		## JUMP =======================================
		if Input.is_action_just_pressed("jump"):
			snap = Vector2.ZERO
			walking = false
			airborn = true
			$AnimatedSprite.set_animation("jump")
			$AnimatedSprite.play()
			velocity.y -= 800
	if dir.x > 0: 
		facing_right = true
		butt.position.x = -abs(butt.position.x)
	elif dir.x < 0:
		facing_right = false
		butt.position.x = abs(butt.position.x)
	$AnimatedSprite.flip_h = !facing_right
	
	velocity += dir * accel
	velocity.x = clamp(velocity.x, -400, 400)
	
	move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP, false, 4, 0.8, false)
	
	if get_slide_count() > 0 && airborn == true:
		velocity.y = 0
		airborn = false
		$AnimatedSprite.set_animation("walk")
		snap = Vector2.DOWN
		
