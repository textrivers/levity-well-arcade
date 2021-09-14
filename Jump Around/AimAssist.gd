extends KinematicBody2D

var mouse_pos: Vector2
var velocity: Vector2
var jump_speed: float = 800
var gravity: float = 1800
var flying = true
var trace
var dot_trans = 0.8

var small_x = preload("res://assets/images/small_x.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Line2D.set_as_toplevel(true)
# warning-ignore:return_value_discarded
	get_parent().connect("jump", self, "on_squirrel_jump")
# warning-ignore:return_value_discarded
	get_parent().connect("land", self, "on_squirrel_land")
	trace = $Trace

func _physics_process(delta):
	if flying == true:
		trace.squirrel_points.append(get_parent().global_position)
		trace.update()
	else:
		position = Vector2(0, 0)
		$Line2D.clear_points()
		var dir
		mouse_pos = get_global_mouse_position()
		dir = mouse_pos - global_position
		dir = dir.normalized()
		velocity = dir * jump_speed
		var point_count = 1
		$Line2D.add_point(global_position)
		while point_count < 100:
			if point_count == 1:
				# velocity.y += (gravity * delta) * 0.6
				pass
			velocity = move_and_slide_with_snap(velocity, Vector2(0, 0), Vector2.UP, false, 1, PI / 2, false)
			if get_slide_count() > 0:
				var coll = get_slide_collision(get_slide_count() - 1)
				var ang = coll.normal.angle()
				if sin(ang) <= 0.01:
					update()
					break
			$Line2D.add_point(global_position)
			velocity.y += gravity * delta
			point_count += 1

func on_squirrel_jump():
	trace.line_points = $Line2D.points
	#$Line2D.clear_points()
	trace.squirrel_points.clear()
	trace.squirrel_points.append(get_parent().global_position)
	flying = true
	dot_trans = 0.0
	update()

func on_squirrel_land():
	dot_trans = 0.8
	flying = false

func _draw():
	var collision
	var circ_pos = Vector2(0, 0)
	if get_slide_count() > 0:
		collision = get_slide_collision(get_slide_count() - 1)
	if collision != null:
		circ_pos = collision.position - self.global_position
		draw_circle(circ_pos, 4.0, Color(0.12, 0.56, 1, dot_trans))
		# draw_texture(small_x, circ_pos - Vector2(5, 5), Color(1, 1, 1, dot_trans))
