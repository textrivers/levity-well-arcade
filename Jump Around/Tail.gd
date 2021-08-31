extends Line2D

export var length = 15
var parent 
var parent_pos = Vector2()
var offsets = [
	Vector2(0, 0),
	Vector2(8, -2),
	Vector2(8, -3),
	Vector2(8, -4),
	Vector2(8, -3),
	Vector2(8, -2),
	Vector2(8, -2),
	Vector2(8, 0),
	Vector2(8, 1),
	Vector2(8, 1),
	Vector2(8, 1),
	Vector2(8, 0),
	Vector2(8, 0),
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	set_as_toplevel(true)
	for _i in range(len(offsets)):
		add_point(Vector2(0, 0))

func _process(_delta):
	
	##if !parent_pos.is_equal_approx(parent.global_position):
	##parent_pos = parent.global_position
	##add_point(parent_pos)
	
	##if get_point_count() > length:
	##	remove_point(0)
	
	for i in range(len(points) - 1, -1, -1):
		if i == 0:
			points[i] = parent.global_position
			continue
		var offset
		if parent.flying:
			offset = Vector2(0, 0)
		else:
			offset = offsets[i]
		points[i] = (offset * Vector2(-parent.right, 1)) + points[i-1]
		

func _on_Timer_timeout():
	points[0].y -= 4
	$Timer.wait_time = randf() + 1
