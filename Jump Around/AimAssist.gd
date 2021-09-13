extends KinematicBody2D

var mouse_pos: Vector2
var velocity: Vector2
var jump_speed: float = 800
var gravity: float = 1800

# Called when the node enters the scene tree for the first time.
func _ready():
	$Line2D.set_as_toplevel(true)

func _physics_process(delta):
	position = Vector2(0, 0)
	$Line2D.clear_points()
	var dir
	mouse_pos = get_global_mouse_position()
	dir = mouse_pos - global_position
	dir = dir.normalized()
	velocity = dir * jump_speed
	var point_count = 0
	while point_count < 100:
		if point_count == 0:
			velocity.y += (gravity * delta) * 0.59
		velocity = move_and_slide(velocity, Vector2.UP, false, 1, PI / 2, false)
		if get_slide_count() > 0:
			## update()
			break
		$Line2D.add_point(global_position)
		velocity.y += gravity * delta
		point_count += 1

func _draw():
	var collision
	if get_slide_count() > 0:
		collision = get_slide_collision(get_slide_count() - 1)
	if collision != null:
		var circ_pos = collision.position - self.global_position
		draw_circle(circ_pos, 4.0, Color.dodgerblue)
	
