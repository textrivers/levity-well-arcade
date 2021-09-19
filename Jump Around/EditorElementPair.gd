extends "res://EditorElement.gd"

func _ready():
	$Child/Sprite.texture = $Sprite.texture
	$Line2D.set_as_toplevel(true)

func _process(delta):
	$Line2D.clear_points()
	$Line2D.add_point(self.position)
	$Line2D.add_point($Child.global_position)
