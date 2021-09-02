extends Line2D

export var length = 15
var squirrel 
var squirrel_pos = Vector2()
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
	squirrel = get_parent().get_parent()
	set_as_toplevel(true)
	for _i in range(len(offsets)):
		add_point(Vector2(0, 0))

func _process(_delta):
	
	for i in range(len(points) - 1, -1, -1):
		if i == 0:
			points[i] = squirrel.butt.global_position
			continue
		var offset
		if squirrel.flying:
			offset = Vector2(0, 0)
		else:
			offset = offsets[i]
		points[i] = (offset * Vector2(-squirrel.right, 1)) + points[i-1]

func _on_Timer_timeout():
	points[0].y -= 6
	points[0].x += 5
	$Timer.wait_time = randf() + 1
