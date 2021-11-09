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
var mouth
var anim_tree
var chomping: bool = false
var art_list = []

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	butt = $Butt
	mouth = $Mouth
	anim_tree = $AnimationTree
	anim_tree.active = true

func _physics_process(delta):
	## CHOMP ============================================
	if chomping == false:
		if Input.is_action_just_pressed("chomp_9"):
			chomping = true
			#$AnimatedSprite.play("chomp")
			anim_tree.set("parameters/TimeScaleChomp/scale", 1.0)
			anim_tree.set("parameters/head_state/current", 2)
	if Input.is_action_just_released("chomp_9"):
		anim_tree.set("parameters/TimeScaleChomp/scale", -12.0)
		$MawTimer.wait_time = 0.3
		$MawTimer.start()
		var chomp_poly: PoolVector2Array = []
		var chomp_xform: Transform2D
		for child in $Mouth/Area2D.get_children():
			if child.disabled == false:
				## small variations in bite shape
				for point in child.polygon:
					chomp_poly.append(point + Vector2(3 - (randi() % 7), 3 - (randi() % 7)))
				chomp_xform = child.global_transform
				break
		do_chomp(chomp_poly, chomp_xform)
	
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
	if !$RayRight.is_colliding() && !$RayLeft.is_colliding():
		if airborn == false:
			airborn = true
	if airborn:
		velocity.y += gravity * delta
		if velocity.y > 0:
			anim_tree.set("parameters/TimeScaleJump/scale", -1)
	else:
		#if walking == false:
		if dir.x != 0:
			walking = true
			if chomping == false:
				#$AnimatedSprite.play("walk")
				anim_tree.set("parameters/head_state/current", 1)
			anim_tree.set("parameters/leg_state/current", 1)
		if dir.x == 0:
			walking = false
			if chomping == false:
				#$AnimatedSprite.stop()
				#$AnimatedSprite.set_frame(0)
				anim_tree.set("parameters/head_state/current", 0)
			anim_tree.set("parameters/leg_state/current", 0)
			velocity.x = 0
		
		## JUMP =======================================
		if Input.is_action_just_pressed("jump"):
			snap = Vector2.ZERO
			walking = false
			airborn = true
			if chomping == false:
				## TODO jump animation
#				$AnimatedSprite.set_animation("jump")
#				$AnimatedSprite.play()
				anim_tree.set("parameters/head_state/current", 0)
			anim_tree.set("parameters/TimeScaleJump/scale", 2)
			anim_tree.set("parameters/leg_state/current", 2)
			velocity.y -= 800
	## ORIENTATION =========================================
	if dir.x > 0: 
		facing_right = true
	elif dir.x < 0:
		facing_right = false
	if facing_right:
		butt.position.x = -abs(butt.position.x)
		#$AnimatedSprite.flip_h = false
		$Rig.scale.x = 1
		$Mouth/Area2D/RightCollision.disabled = false
		$Mouth/Area2D/LeftCollision.disabled = true
	else:
		butt.position.x = abs(butt.position.x)
		#$AnimatedSprite.flip_h = true
		$Rig.scale.x = -1
		$Mouth/Area2D/RightCollision.disabled = true
		$Mouth/Area2D/LeftCollision.disabled = false
	
	velocity += dir * accel
	velocity.x = clamp(velocity.x, -400, 400)
	
# warning-ignore:return_value_discarded
	move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP, true, 4, 0.8, false)
	
	## LANDING ===============================
	if get_slide_count() > 0 && airborn == true:
		velocity.y = 0
		airborn = false
		if chomping == false:
			#$AnimatedSprite.set_animation("walk")
			anim_tree.set("parameters/leg_state/current", 1)
		snap = Vector2.DOWN

func do_chomp(chomp_poly: PoolVector2Array, chomp_xform):
	if art_list.size() > 0:
		for body in art_list:
			body.carve_polygons(chomp_poly, chomp_xform)

func _on_Area2D_body_entered(body):
	art_list.append(body)

func _on_Area2D_body_exited(body):
	art_list.erase(body)

func _on_MawTimer_timeout():
	anim_tree.set("parameters/head_state/current", 0)
	chomping = false

func _draw():
	draw_circle(Vector2(65, 65), 4, Color.rebeccapurple)
	draw_circle(Vector2(-65, 65), 4, Color.rebeccapurple)
