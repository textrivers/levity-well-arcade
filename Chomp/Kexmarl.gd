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
var chomp_counter: int = 0
var chomping: bool = false
var chomp_min: int = 4
var art_list = []
signal chomp

# Called when the node enters the scene tree for the first time.
func _ready():
	butt = $AnimatedSprite/Butt

func _physics_process(delta):
	## CHOMP ============================================
	chomp_counter = 0
	if chomping == false:
		if Input.is_action_pressed("chomp_h"):
			chomp_counter += 1
		if Input.is_action_pressed("chomp_j"):
			chomp_counter += 1
		if Input.is_action_pressed("chomp_k"):
			chomp_counter += 1
		if Input.is_action_pressed("chomp_l"):
			chomp_counter += 1
		if Input.is_action_pressed("chomp_y"):
			chomp_counter += 1
		if Input.is_action_pressed("chomp_u"):
			chomp_counter += 1
		if Input.is_action_pressed("chomp_i"):
			chomp_counter += 1
		if Input.is_action_pressed("chomp_o"):
			chomp_counter += 1
		if Input.is_action_pressed("chomp_6"):
			chomp_counter += 1
		if Input.is_action_pressed("chomp_7"):
			chomp_counter += 1
		if Input.is_action_pressed("chomp_8"):
			chomp_counter += 1
		if Input.is_action_pressed("chomp_9"):
			chomp_counter += 1
		if chomp_counter >= chomp_min:
			chomping = true
			$AnimatedSprite.play("chomp")
	
	## POOP =============================================
	if Input.is_action_pressed("rightclick"):
		var new_ball = preload("res://SmallBall.tscn").instance()
		get_parent().add_child(new_ball)
		new_ball.global_position = butt.global_position
		new_ball.global_position.x += float(randi() % 3)
		new_ball.rotation += randf()
	
	## MOVEMENT =======================================
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
				if chomping == false:
					$AnimatedSprite.play("walk")
		if dir.x == 0:
			walking = false
			if chomping == false:
				$AnimatedSprite.stop()
				$AnimatedSprite.set_frame(0)
			velocity.x = 0
		
		## JUMP =======================================
		if Input.is_action_just_pressed("jump"):
			print(chomp_counter)
			snap = Vector2.ZERO
			walking = false
			airborn = true
			if chomping == false:
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
	
# warning-ignore:return_value_discarded
	move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP, false, 4, 0.8, false)
	
	## LANDING ===============================
	if get_slide_count() > 0 && airborn == true:
		velocity.y = 0
		airborn = false
		if chomping == false:
			$AnimatedSprite.set_animation("walk")
		snap = Vector2.DOWN

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "chomp":
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.play()
		chomping = false

func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.frame == 4:
		do_chomp()

func do_chomp():
	for body in art_list:
		## TODO call carve function, use Geometry.clip_polygons_2D to make the good things happen
		pass

func _on_Area2D_body_entered(body):
	art_list.append(body)

func _on_Area2D_body_exited(body):
	art_list.erase(body)
