extends Line2D

export var max_dist = 6
var squirrel 
var squirrel_pos = Vector2()
var offsets = [
	Vector2(0, 0),
	Vector2(5, -1),
	Vector2(5, -2),
	Vector2(5, -2),
	Vector2(5, -3),
	Vector2(5, -2),
	Vector2(5, -1),
	Vector2(5, 0),
	Vector2(5, 1),
	Vector2(5, 1),
	Vector2(5, 1),
	Vector2(5, 0),
	Vector2(5, 0),
	]


# Called when the node enters the scene tree for the first time.
func _ready():
	squirrel = get_parent().get_parent()
	set_as_toplevel(true)
	for _i in range(len(offsets)):
		add_point(Vector2(0, 0))

func _process(_delta):
	## starting at back of tail, each point takes the position its anterior neighbor had in previous frame
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
	## adjust position from front to back to enforce maximum distance between points
	for i in range(len(points)):
		if i == 0:
			continue
		if points[i].distance_to(points[i-1]) > max_dist:
			var dir = points[i-1].direction_to(points[i])
			points[i] = points[i-1] + (dir * max_dist)

func _on_Timer_timeout():
	points[0].y -= 6
	points[0].x += 5
	$Timer.wait_time = randf() + 1
