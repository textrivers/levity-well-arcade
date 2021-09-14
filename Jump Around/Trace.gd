extends Node2D

var squirrel_points = []
var line_points = []

func _ready():
	set_as_toplevel(true)

func _draw():
	for spoint in squirrel_points:
		draw_circle(spoint, 4.0, Color.webgray)
	for lpoint in line_points:
		draw_circle(lpoint, 4.0, Color.dodgerblue)
