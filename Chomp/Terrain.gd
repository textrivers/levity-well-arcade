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
	if Input.is_action_pressed("leftclick"):
		var click_pos = get_global_mouse_position()
		carve_polygons(click_pos)
	if Input.is_action_pressed("rightclick"):
		var smallball = load("res://SmallBall.tscn").instance()
		var click_pos = get_global_mouse_position()
		add_child(smallball)
		smallball.position = click_pos

func carve_polygons(click):
	var new_poly: PoolVector2Array = []
	for point in default_sq:
		new_poly.append(point + click)
	var result = Geometry.clip_polygons_2d($Collision/Visible.polygon, new_poly)
	if result.size() == 0:
		return
	else:
		for res in range(result.size()):
			if res == 0:
				$Collision/Visible.polygon = result[0]
				$Collision.set_deferred("polygon", result[0])
			if res > 0:
				var new_col = CollisionPolygon2D.new()
				var new_vis = Polygon2D.new()
				new_vis.polygon = result[res]
				new_col.polygon = result[res]
				new_vis.texture = $Collision/Visible.texture
				var new_rig = RigidBody2D.new()
				add_child(new_rig)
				new_rig.add_child(new_col)
				new_col.add_child(new_vis)
