extends RigidBody2D

## some functions cribbed from:
## https://github.com/SoloByte/godot-polygon2d-fracture 

func _ready():
	var match_poly = $CollPoly.polygon
	$CollPoly/VisPoly.polygon = match_poly
	##$CollPoly/VisPoly.texture_offset.x += ($CollPoly/VisPoly.texture.get_width() / 2)
	## $CollPoly/VisPoly.texture_offset.y += ($CollPoly/VisPoly.texture.get_height() / 2)
	update()

func carve_polygons(chomp_poly, chomp_xform):
	var result = cutShape($CollPoly.polygon, chomp_poly, $CollPoly.global_transform, chomp_xform)
	var final = result["final"]
	for res in range(final.size()):
		if res == 0:
			$CollPoly/VisPoly.polygon = final[0]
			$CollPoly.set_deferred("polygon", final[0])
		if res > 0:
			var new_rig = load("res://Art.tscn").instance()
			get_parent().add_child(new_rig)
			new_rig.get_node("CollPoly").polygon = final[res]
			new_rig.get_node("CollPoly/VisPoly").polygon = final[res]
			new_rig.get_node("CollPoly/VisPoly").texture = $CollPoly/VisPoly.texture
			new_rig.position = position
			##TODO offset new_vis texture by distance from center of old vis

#CUTTING AND RESTORING
#-------------------------------------------------------------------------------
#cut polygon = cut shape used to cut source polygon
#get_intersect determines if the the intersected area (area shared by both polygons, the area that is cut out of the source polygon) is returned as well
#returns dictionary with final : Array and intersected : Array -> all holes are filtered out already
static func cutShape(source_polygon : PoolVector2Array, cut_polygon : PoolVector2Array, source_trans_global : Transform2D, cut_trans_global : Transform2D) -> Dictionary:
	var cut_pos : Vector2 = toLocal(source_trans_global, cut_trans_global.get_origin())
	
	cut_polygon = rotatePolygon(cut_polygon, cut_trans_global.get_rotation() - source_trans_global.get_rotation())
	cut_polygon = translatePolygon(cut_polygon, cut_pos)
	
	var intersected_polygons : Array = intersectPolygons(source_polygon, cut_polygon, true)
	if intersected_polygons.size() <= 0:
		return {"final" : [], "intersected" : []}
	
	var final_polygons : Array = clipPolygons(source_polygon, cut_polygon, true)
	
	return {"final" : final_polygons, "intersected" : intersected_polygons}

static func clipPolygons(poly_a : PoolVector2Array, poly_b : PoolVector2Array, exclude_holes : bool = true) -> Array:
	var new_polygons : Array = Geometry.clip_polygons_2d(poly_a, poly_b)
	if exclude_holes:
		return getCounterClockwisePolygons(new_polygons)
	else:
		return new_polygons

static func intersectPolygons(poly_a : PoolVector2Array, poly_b : PoolVector2Array, exclude_holes : bool = true) -> Array:
	var new_polygons : Array = Geometry.intersect_polygons_2d(poly_a, poly_b)
	if exclude_holes:
		return getCounterClockwisePolygons(new_polygons)
	else:
		return new_polygons

#moves all points of the polygon by offset
static func translatePolygon(poly : PoolVector2Array, offset : Vector2) -> PoolVector2Array:
	var new_poly : PoolVector2Array = []
	for p in poly:
		new_poly.append(p + offset)
	return new_poly

#rotates all points of the polygon by rot (in radians)
static func rotatePolygon(poly : PoolVector2Array, rot : float) -> PoolVector2Array:
	var rotated_polygon : PoolVector2Array = []
	
	for p in poly:
		rotated_polygon.append(p.rotated(rot))
	
	return rotated_polygon
	
#checks all polygons in the array and only returns not clockwise (counter clockwise) polygons (filled polygons)
static func getCounterClockwisePolygons(polygons : Array) -> Array:
	var ccw_polygons : Array = []
	for poly in polygons:
		if not Geometry.is_polygon_clockwise(poly):
			ccw_polygons.append(poly)
	return ccw_polygons

#does the same as Node.toGlobal()
static func toGlobal(global_transform : Transform2D, local_pos : Vector2) -> Vector2:
	return global_transform.xform(local_pos)

#does the same as Node.toLocal()
static func toLocal(global_transform : Transform2D, global_pos : Vector2) -> Vector2:
	return global_transform.affine_inverse().xform(global_pos)

func _draw():
	draw_circle(Vector2(0, 0), 10, Color(0.8, 0.4, 0.4, 0.8))

