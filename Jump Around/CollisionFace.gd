extends StaticBody2D

var sprite 
var tex_width
var tex_height
var poly: PoolVector2Array = []
var verts: PoolVector2Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $Sprite2
	tex_width = sprite.texture.get_width()
	tex_height = sprite.texture.get_height()

func _process(_delta):
	if Input.is_action_just_pressed("collidify"):
		_create_collision_polygon()
	if Input.is_action_just_pressed("meshify"):
		_create_collision_mesh()

func _create_collision_polygon():
	var startclick = OS.get_ticks_usec()
	var bm = BitMap.new()
	bm.create_from_image_alpha(sprite.texture.get_data())
	var rect = Rect2(position.x, position.y, tex_width, tex_height)
	var my_array = bm.opaque_to_polygons(rect, 0.2)
	var my_polygon = Polygon2D.new()
	my_polygon.set_polygons(my_array)
	print(my_polygon.polygons.size())
	for i in range(my_polygon.polygons.size()):
		var my_collision = CollisionPolygon2D.new()
		poly = my_polygon.polygons[i]
		print(poly.size())
		for j in range(poly.size() - 1, 0, -2):
			poly.remove(j)
		print(poly.size())
		my_collision.set_polygon(poly)
		my_collision.scale = scale
		my_collision.position.x -= tex_width / 2
		my_collision.position.y -= tex_height / 2
		call_deferred("add_child", my_collision)
	var endclick = OS.get_ticks_usec()
	print(float(endclick - startclick) / 1000000)

func _create_collision_mesh():
	var mesh = $Sprite2.mesh
	var startclick = OS.get_ticks_usec()
	verts = mesh.surface_get_arrays(0)[0]
#	print(verts.size())
#	while verts.size() > 10:
#		for i in range(verts.size() - 1, 0, -2):
#			verts.remove(i)
#	print(verts.size())
#	var my_arr = [verts, [], [], [], [], [], [], [], []]
#	mesh.add_surface_from_arrays(4, my_arr)
#	mesh.surface_remove(mesh.get_surface_count() - 1)
	update()
	var my_polygon = Polygon2D.new()
	my_polygon.set_polygons(verts)
	var my_collision = CollisionPolygon2D.new()
	my_collision.set_polygon(my_polygon.polygons)
	call_deferred("add_child", my_collision)
	var endclick = OS.get_ticks_usec()
	print(float(endclick - startclick) / 1000000)

func _draw():
	for i in range(verts.size()):
		if i == (verts.size() - 1):
			draw_line(verts[i], verts[0], Color.cornflower)
			print("last line")
			continue
		#draw_circle(vert, 1.0, Color.cornflower)
		draw_line(verts[i], verts[i + 1], Color.cornflower)
