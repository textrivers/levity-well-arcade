extends StaticBody2D

var sprite 
var tex_width
var tex_height
var poly: PoolVector2Array = []
var verts: PoolVector2Array = []
var tex = preload("res://assets/images/test_face.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $Sprite2
	tex_width = sprite.texture.get_width()
	tex_height = sprite.texture.get_height()

func _process(_delta):
	if Input.is_action_just_pressed("collidify"):
		subtract_from_mesh()
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
	## verts now an array of vertices
	update()
	var my_polygon = Polygon2D.new()
	my_polygon.set_polygons(verts)
	var my_collision = CollisionPolygon2D.new()
	my_collision.set_polygon(my_polygon.polygons)
	call_deferred("add_child", my_collision)
	var endclick = OS.get_ticks_usec()
	print(float(endclick - startclick) / 1000000)

func subtract_from_mesh():
	randomize()
	var mesh = $Sprite2.mesh
	var startclick = OS.get_ticks_usec()
	var surf = mesh.surface_get_arrays(0)
	verts = surf[Mesh.ARRAY_VERTEX]
	var uvs = surf[Mesh.ARRAY_TEX_UV]
	var indices = surf[Mesh.ARRAY_INDEX]
	## get random vertex
	var vert_max = verts.size()
	var rand_vert = verts[randi() % vert_max]
	## remove vertices within 50px
	var count: int = 0
	var high_index: int = -1
	var low_index: int = 999999
	for j in range((verts.size() - 1), 0, -1):
		if verts[j] == rand_vert || verts[j].distance_to(rand_vert) < 50:
			verts.remove(j)
			uvs.remove(j)
			indices.remove(j)
			if j > high_index:
				high_index = j
			if j < low_index:
				low_index = j
	## backfill count of vertices at the same indices but in a straight line; 
	## set their UVs somehow?
	## TODO or you could just do what the guy on YouTube did
	if count > 0:
		for k in range(count):
			pass
	## use ArrayMesh functionality to change Sprite2 mesh
	var arr = []
	arr.resize(Mesh.ARRAY_MAX)
	arr[Mesh.ARRAY_VERTEX] = verts
	arr[Mesh.ARRAY_TEX_UV] = uvs
	arr[Mesh.ARRAY_INDEX] = indices
	# Create mesh surface from mesh array and remove previous.
	mesh.surface_remove(0)
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)
	## use SurfaceTool to index
	#var st = SurfaceTool.new()
#	st.create_from(mesh, 0)
#	st.index()
#	arr = st.commit_to_arrays()
#	mesh.surface_remove(0)
#	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)
	_create_collision_mesh()
	var endclick = OS.get_ticks_usec()
	print(float(endclick - startclick) / 1000000)

func _draw():
	for i in range(verts.size()):
		if i == (verts.size() - 1):
			draw_line(verts[i], verts[0], Color.cornflower)
			continue
		#draw_circle(vert, 1.0, Color.cornflower)
		draw_line(verts[i], verts[i + 1], Color.cornflower)
