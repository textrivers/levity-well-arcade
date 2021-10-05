extends Node2D

var orig_tex
var orig: bool = true
var new_tex
var alpha_threshold: float = 0.5
var bool_field = []

func _ready():
	$HSlider.value = alpha_threshold
	orig_tex = $Sprite.texture

func _process(_delta):
	if Input.is_action_just_pressed("rightclick"):
		var startclick = OS.get_ticks_usec()
		## toggle original texture and SDF representation
		if orig == true: 
			orig = false
			## sample sprite texture to build boolean field
			build_boolean_field()
			## convert boolean field to SDF by marching the parabolas
			var new_SDF = boolean_to_SDF()
			## create new image texture from the SDF 
			## load that as sprite texture 
			display_new_field(new_SDF)
			var endclick = OS.get_ticks_usec()
			print(float(endclick - startclick) / 1000000)
		else:
			orig = true
			$Sprite.texture = orig_tex

func build_boolean_field():
	bool_field = []
	var image_raw: Image = $Sprite.texture.get_data()
	var image_dimensions: Vector2 = $Sprite.texture.get_size()
	image_raw.lock()
	for x in image_dimensions.x:
		bool_field.append([])
		for y in image_dimensions.y: 
			if image_raw.get_pixel(x, y).a < alpha_threshold:
				bool_field[x].append(false)
			else:
				bool_field[x].append(true)
	image_raw.unlock()

func boolean_to_SDF():
	## create new Euclidian Distance transform array 
	## that replaces true with 0 and false with INF
	## and inverse
	var new_real_field = []
	var new_inv_real_field = []
	for x in bool_field.size():
		new_real_field.append([])
		new_inv_real_field.append([])
		for y in bool_field[x].size():
			if bool_field[x][y] == true:
				new_real_field[x].append(0)
				new_inv_real_field[x].append(INF)
			else:
				new_real_field[x].append(INF)
				new_inv_real_field[x].append(0)
	var new_EDT = compute_EDT(new_real_field)
	## return new_EDT
	var new_inv_EDT = compute_EDT(new_inv_real_field)
	var SDF = compute_SDF(new_EDT, new_inv_EDT)
	return SDF

func compute_EDT(field):
	## see https://prideout.net/blog/distance_fields/
	### do a pass on each column, rotate; repeat but rotate back; then sqrt whole
	for column in field.size():
		vertical_pass(field[column])
	field = rotate_field(field, true)
	for column in field.size():
		vertical_pass(field[column])
	rotate_field(field, false)
	for x in field.size():
		for y in field[x].size():
			field[x][y] = sqrt(field[x][y])
	return field

func vertical_pass(column):
	### find the parabola hull for the column from a list of all parabolas, 
	### then march the parabolas to sample the height at each pixel center
	var hull_vertices = []
	var hull_intersections = []
	find_hull_parabolas(column, hull_vertices, hull_intersections)
	march_parabolas(column, hull_vertices, hull_intersections)

func find_hull_parabolas(col, hull_verts, hull_inters):
#    d = single_row
#    v = hull_vertices
#    z = hull_intersections
#    k = 0
	var k = 0
#    v[0].x = 0
	hull_verts.append(Vector2(0, 0))
#    z[0].x = -INF
	hull_inters.append(Vector2(-INF, 0))
#    z[1].x = +INF
	hull_inters.append(Vector2(INF, 0))
#    for i in range(1, len(d)):
	for i in range(1, len(col)):
#        q = (i, d[i])
		var q = Vector2(i, col[i])
#        p = v[k]
		var p = hull_verts[k]
#        s = intersect_parabolas(p, q)
		var s = Vector2(0, 0)
		s = intersect_parabolas(p, q)
#        while s.x <= z[k].x:
		while s.x <= hull_inters[k].x:
#            k = k - 1
			k = k - 1
#            p = v[k]
			p = hull_verts[k]
#            s = intersect_parabolas(p, q)
			s = intersect_parabolas(p, q)
#        k = k + 1
		k += 1
#        v[k] = q
		if k >= hull_verts.size():
			hull_verts.append(q)
		else:
			hull_verts[k] = q
#        z[k].x = s.x
		if k >= hull_inters.size():
			hull_inters.append(Vector2(s.x, 0))
		else:
			hull_inters[k].x = s.x
#        z[k + 1].x = +INF
		if k + 1 >= hull_inters.size():
			hull_inters.append(Vector2(INF, 0))
		else:
			hull_inters[k + 1].x = INF
		
		
## Find intersection between parabolas at the given vertices.
#def intersect_parabolas(p, q):
func intersect_parabolas(_p, _q):
#    x = ((q.y + q.x*q.x) - (p.y + p.x*p.x)) / (2*q.x - 2*p.x)
	var _x = ((_q.y + _q.x * _q.x) - (_p.y + _p.x * _p.x)) / (2 * _q.x - 2 * _p.x)
#    return x, _
	return Vector2(_x, 0)

func march_parabolas(col, hull_verts, hull_inters):
#	d = single_row
#    v = hull_vertices
#    z = hull_intersections
#    k = 0
	var k = 0
#    for q in range(len(d)):
	for q in range(len(col)):
#        while z[k + 1].x < q:
		while hull_inters[k + 1].x < q:
#            k = k + 1
			k += 1
#        dx = q - v[k].x
		var dx = q - hull_verts[k].x
#        d[q] = dx * dx + v[k].y
		col[q] = dx * dx + hull_verts[k].y

func rotate_field(field, clockwise):
	var new_field = []
	new_field.resize(field[0].size())
	for x in new_field.size():
		new_field[x] = []
		new_field[x].resize(field.size())
	if clockwise:
		print("clockwise")
		for x in new_field.size():
			field[x].invert()
		for x in new_field.size():
			for y in new_field[x].size():
				new_field[x][y] = field[y][x]
	else:
		print("counterclockwise")
		for x in new_field.size():
			for y in new_field[x].size():
				new_field[x][y] = field[y][x]
		for x in new_field.size():
			new_field[x].invert()
	return new_field

func compute_SDF(EDT, invEDT):
	### subtract inverse from original and return as SDF
	for x in EDT.size():
		for y in EDT[0].size():
			EDT[x][y] -= invEDT[x][y]
	return EDT

func display_new_field(field):
	var new_im = Image.new()
	new_im.create(field.size(), field[0].size(), false, Image.FORMAT_RGBA8)
	new_im.lock()
	for x in field.size():
		for y in field[x].size(): 
			var v = clamp(abs(1 / (field[x][y] + 0.001)), 0.001, 1.0) 
			new_im.set_pixel(x, y, Color(v, v, v))
	new_tex = ImageTexture.new()
	new_tex.create_from_image(new_im, 1)
	new_im.unlock()
	$Sprite.texture = new_tex

func _on_HSlider_value_changed(value):
	alpha_threshold = value
