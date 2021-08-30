extends KinematicBody2D

var velocity = Vector2()
var mouse_pos = Vector2()
var dir = Vector2()
var jump_speed = 1000
var up = Vector2()
var down = Vector2()
var eye

func _ready():
	up = Vector2(0, -1)
	down = Vector2(0, 1)
	eye = $Sprite/Sprite

func _physics_process(_delta):
	mouse_pos = get_global_mouse_position()
	if Input.is_action_just_pressed("jump"):
		## get mouse location; ml - pos = dir; dir.normalized times jumpspeed = vel, call move/slide/snap, reorient on collision
		
		dir = mouse_pos - position
		dir = dir.normalized()
		velocity = dir * jump_speed
		
	velocity = move_and_slide_with_snap(velocity, down, up, true, 1, 0.8, false)
	
	## collision
	if get_slide_count() > 0:
		velocity = Vector2(0, 0)
		var collision = get_slide_collision(get_slide_count() - 1)
		up = collision.normal
		down = up * -1
	
	eye.look_at(mouse_pos)
