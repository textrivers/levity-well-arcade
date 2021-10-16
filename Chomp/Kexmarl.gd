extends KinematicBody2D

var gravity = 400
var dir: Vector2 = Vector2(0, 0)
var accel = 20
var velocity: Vector2 = Vector2(0, 0)
var airborn: bool = true
var facing_right: bool = true
var walking: bool = false
var snap: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	dir = Vector2(0, 0)
	if Input.is_action_pressed("move_left"):
		dir += Vector2.LEFT
	if Input.is_action_pressed("move_right"):
		dir += Vector2.RIGHT
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
		
		if Input.is_action_just_pressed("jump"):
			snap = Vector2.ZERO
			walking = false
			airborn = true
			$AnimatedSprite.set_animation("jump")
			$AnimatedSprite.play()
			velocity.y -= 600
	if dir.x > 0: 
		facing_right = true
	elif dir.x < 0:
		facing_right = false
	$AnimatedSprite.flip_h = !facing_right
	
	velocity += dir * accel
	velocity.x = clamp(velocity.x, -400, 400)
	
	move_and_slide_with_snap(velocity, snap, Vector2.UP)
	
	if get_slide_count() > 0:
		airborn = false
		$AnimatedSprite.set_animation("walk")
		snap = Vector2.DOWN
		
