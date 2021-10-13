extends StaticBody2D

var default_sq = [
	Vector2(-10, -10), 
	Vector2(10, -10), 
	Vector2(10, 10),
	Vector2(-10, 10)
]

# Called when the node enters the scene tree for the first time.
func _ready():
	var match_poly = $Collision.polygon
	$Collision/Visible.polygon = match_poly
	$Collision/Visible.texture_offset.x += ($Collision/Visible.texture.get_width() / 2)
	$Collision/Visible.texture_offset.y += ($Collision/Visible.texture.get_height() / 2)

func _input(event):
	if Input.is_action_just_pressed("leftclick"):
		pass
		## get click location
		## carve it out of existing polygon
		## set the visible polygon to match
