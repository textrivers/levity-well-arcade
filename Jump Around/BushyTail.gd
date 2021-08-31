extends Node2D

var squirrel

var points = [ 
	#[(offset), max_dist, (pos), radius]
	[Vector2(0, 0), 0, Vector2(0, 0), 4],
	[Vector2(4, 0), 0, Vector2(0, 0), 4],
	[Vector2(4, -2), 5, Vector2(0, 0), 6],
	[Vector2(4, -2), 5, Vector2(0, 0), 6],
	[Vector2(4, -1), 5, Vector2(0, 0), 8],
	[Vector2(4, -1), 5, Vector2(0, 0), 8],
	[Vector2(4, 0), 5, Vector2(0, 0), 10],
	[Vector2(4, 0), 5, Vector2(0, 0), 10],
	[Vector2(4, 1), 5, Vector2(0, 0), 12],
	[Vector2(4, 1), 5, Vector2(0, 0), 12],
	[Vector2(4, 1), 5, Vector2(0, 0), 14],
	[Vector2(4, 0), 5, Vector2(0, 0), 14],
	[Vector2(4, 0), 5, Vector2(0, 0), 12],
	]

func _ready():
	set_as_toplevel(true)
	squirrel = get_parent()

func _process(_delta):
	for i in range(len(points) - 1, -1, -1):
		if i == 0:
			points[i][2] = squirrel.global_position
			continue
		points[i][2] = (points[i][0] * Vector2(-squirrel.right, 1)) + points[i-1][2]
	update()

func _draw():
	for point in points:
		draw_circle(point[2], point[3], Color.brown)
