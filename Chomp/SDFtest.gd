extends Node2D

var orig_tex
var orig: bool = true
var new_tex
var alpha_threshold: float = 0.5
var bool_field = []
var startclick

const FIN = 100000

func _ready():
	$HSlider.value = alpha_threshold
	orig_tex = $Sprite.texture

func _process(_delta):
	if Input.is_action_just_pressed("rightclick"):
		startclick = OS.get_ticks_usec()
		## toggle original texture and SDF representation
		if orig == true: 
			orig = false
			## sample sprite texture to build boolean field
			## convert boolean field to SDF by marching the parabolas
			var new_SDF = boolean_to_SDF()
			## create new image texture from the SDF 
			## load that as sprite texture 
			display_new_field(new_SDF)
			var endclick = OS.get_ticks_usec()
			print("end = " + str(float(endclick - startclick) / 1000000))
		else:
			orig = true
			$Sprite.texture = orig_tex

func boolean_to_SDF():
	## create new Euclidian Distance transform array 
	## that replaces true with 0 and false with INF
	## and inverse
	var new_real_field = []
	var new_inv_real_field = []
	var image_raw: Image = $Sprite.texture.get_data()
	var image_dimensions: Vector2 = $Sprite.texture.get_size()
	image_raw.lock()
	for x in image_dimensions.x:
		new_real_field.append([])
		new_inv_real_field.append([])
		for y in image_dimensions.y: 
			if image_raw.get_pixel(x, y).a < alpha_threshold:
				new_real_field[x].append(FIN)
				new_inv_real_field[x].append(0)
			else:
				new_real_field[x].append(0)
				new_inv_real_field[x].append(FIN)
	image_raw.unlock()
	var get_ticks = OS.get_ticks_usec()
	print("done sampling image = " + str(float(get_ticks - startclick) / 1000000))
	var new_EDT = compute_EDT(new_real_field)
	get_ticks = OS.get_ticks_usec()
	print("done computing EDT = " + str(float(get_ticks - startclick) / 1000000))
	#return new_EDT
	var new_inv_EDT = compute_EDT(new_inv_real_field)
	get_ticks = OS.get_ticks_usec()
	print("done computing inverse EDT = " + str(float(get_ticks - startclick) / 1000000))
	#return new_inv_EDT
	var SDF = compute_SDF(new_EDT, new_inv_EDT)
	get_ticks = OS.get_ticks_usec()
	print("done computing SDF = " + str(float(get_ticks - startclick) / 1000000))
	return SDF

func compute_EDT(field):
	## see https://prideout.net/blog/distance_fields/
	### do a pass on each column, rotate; repeat but rotate back; then sqrt whole
	for column in field.size():
		vertical_pass(field[column])
	field = rotate_field(field, true)
	for column in field.size():
		vertical_pass(field[column])
	field = rotate_field(field, false)
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
	hull_verts.append(Vector2(0, FIN))
#    z[0].x = -INF
	hull_inters.append(Vector2(-FIN, 0))
#    z[1].x = +INF
	hull_inters.append(Vector2(FIN, 0))
#    for i in range(1, len(d)):
	for i in range(1, col.size()):
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
			hull_verts.append(Vector2())
		#else:
		hull_verts[k] = q
#        z[k].x = s.x
		if k >= hull_inters.size():
			hull_inters.append(Vector2())
		#else:
		hull_inters[k].x = s.x
#        z[k + 1].x = +INF
		if k + 1 >= hull_inters.size():
			hull_inters.append(Vector2())
		#else:
		hull_inters[k + 1].x = FIN
		
		
## Find intersection between parabolas at the given vertices.
#def intersect_parabolas(p, q):
func intersect_parabolas(_p, _q):
#    x = ((q.y + q.x*q.x) - (p.y + p.x*p.x)) / (2*q.x - 2*p.x)
	var _x = ((_q.y + (_q.x * _q.x)) - (_p.y + (_p.x * _p.x))) / ((2 * _q.x) - (2 * _p.x))
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
		for x in new_field.size():
			field[x].invert()
		for x in new_field.size():
			for y in new_field[x].size():
				new_field[x][y] = field[y][x]
	else:
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
			#var v = clamp(abs(1 - (1 / (float(field[x][y]) + 0.001))), 0.001, 1.0) 
			if field[x][y] > 0 && int(field[x][y]) % 10 == 0:
				new_im.set_pixel(x, y, Color.cornflower)
			elif field[x][y] == 1:
				new_im.set_pixel(x, y, Color.crimson)
			else:
				var v = clamp(float(field[x][y] * 0.025 + 0.5), 0.0, 1.0)
				new_im.set_pixel(x, y, Color(v, v, v))
	new_tex = ImageTexture.new()
	new_tex.create_from_image(new_im, 1)
	new_im.unlock()
	$Sprite.texture = new_tex

func _on_HSlider_value_changed(value):
	alpha_threshold = value
