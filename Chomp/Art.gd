extends RigidBody2D

func _ready():
	var match_poly = $CollPoly.polygon
	$CollPoly/VisPoly.polygon = match_poly
	##$CollPoly/VisPoly.texture_offset.x += ($CollPoly/VisPoly.texture.get_width() / 2)
	## $CollPoly/VisPoly.texture_offset.y += ($CollPoly/VisPoly.texture.get_height() / 2)

func carve_polygons(chomp_poly):
	var result = Geometry.clip_polygons_2d($CollPoly/VisPoly.polygon, chomp_poly)
	if result.size() == 0:
		return
	else:
		for res in range(result.size()):
			if res == 0:
				$CollPoly/VisPoly.polygon = result[0]
				$CollPoly.set_deferred("polygon", result[0])
			if res > 0:
				var new_rig = load("res://Art.tscn").instance()
				get_parent().add_child(new_rig)
				new_rig.get_node("CollPoly").polygon = result[res]
				new_rig.get_node("CollPoly/VisPoly").polygon = result[res]
				new_rig.get_node("CollPoly/VisPoly").texture = $CollPoly/VisPoly.texture
				new_rig.position = position
				##TODO offset new_vis texture by distance from center of old vis


