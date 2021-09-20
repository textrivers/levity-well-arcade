extends "res://EditorElement.gd"

var twin
var has_twin = false

func _ready():
	$Line2D.set_as_toplevel(true)

func _process(_delta):
	if has_twin:
		$Line2D.clear_points()
		$Line2D.add_point(self.position)
		$Line2D.add_point(twin.global_position)

