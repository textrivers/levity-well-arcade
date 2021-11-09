extends RigidBody2D

var plib

func _ready():
	var match_poly = $CollPoly.polygon
	$CollPoly/VisPoly.polygon = match_poly
	plib = PolygonLib.new()
	#$CollPoly/VisPoly.texture_offset.x -= ($CollPoly/VisPoly.texture.get_width() / 2)
	#$CollPoly/VisPoly.texture_offset.y -= ($CollPoly/VisPoly.texture.get_height() / 2)
	update()

func carve_polygons(chomp_poly, chomp_xform):
	var result = plib.cutShape($CollPoly.polygon, chomp_poly, $CollPoly.global_transform, chomp_xform)
	var final = result["final"]
	for res in range(final.size()):
		if res == 0:
			$CollPoly/VisPoly.polygon = final[0]
			$CollPoly.set_deferred("polygon", final[0])
		if res > 0:
			var new_art = load("res://Art.tscn").instance()
			get_parent().add_child(new_art)
			## set new art center to polygon centroid
			var centroid = plib.calculatePolygonCentroid(final[res])
			print(centroid)
			new_art.global_position = centroid + position
			## center polygon on polygon centroid
			var centered_poly = plib.centerPolygon(final[res])
			## set new art coll poly and vis poly
			new_art.get_node("CollPoly").polygon = centered_poly
			new_art.get_node("CollPoly/VisPoly").polygon = centered_poly
			## set texture with offset
			new_art.get_node("CollPoly/VisPoly").texture = $CollPoly/VisPoly.texture
			new_art.get_node("CollPoly/VisPoly").texture_offset = new_art.position - position + $CollPoly/VisPoly.texture_offset

func _draw():
	draw_circle(Vector2(0, 0), 10, Color(0.8, 0.4, 0.4, 0.8))

