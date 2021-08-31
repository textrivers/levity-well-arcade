extends KinematicBody2D

var velocity = Vector2()
var mouse_pos = Vector2()
var dir = Vector2()
var jump_speed = 800
var gravity = 1500
var up = Vector2()
var down = Vector2()
var flying = false
var rig
var lerp_rot
var old_rot
var right = 1

func _ready():
	up = Vector2(0, -1)
	down = Vector2(0, 1)
	rig = $Rig
	lerp_rot = rotation
	old_rot = rotation

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
		up = dir
		lerp_rot = up.angle() + deg2rad(90)
		velocity = dir * jump_speed
		## rotation = lerp_rot
		## rotate(lerp_rot - rotation)
	
	if flying:
		rotation = lerp_angle(rotation, lerp_rot, 0.2)
		velocity.y += gravity * delta
	else: rotation = lerp_rot
	velocity = move_and_slide_with_snap(velocity, down, up, true, 1, 0.8, false)
	
	## collision
	if get_slide_count() > 0 && flying == true:
		flying = false
		velocity = Vector2(0, 0)
		var collision = get_slide_collision(get_slide_count() - 1)
		up = collision.normal
		down = -up 
		## rotation
		lerp_rot = up.angle() + deg2rad(90)
		old_rot = rotation
		## TODO fix arms
		## var coll_angle = position.angle_to(collision.position)
		## var cast_to_angle = coll_angle - 0.05
		## $LimbRay.cast_to = Vector2(cos(cast_to_angle), sin(cast_to_angle)) * 30
		## print($LimbRay.cast_to)
		## if $LimbRay.is_colliding():
	## 		print("collision at " + str(OS.get_ticks_msec()))
		## 	$LimbRay/ArmLeft.points[1] = $LimbRay.get_collision_point()
	
		
	
	rig.look_at(mouse_pos)
