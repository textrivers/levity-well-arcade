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
		## toggle original texture and SDF representation
		if orig == true: 
			orig = false
			## sample sprite texture to build boolean field
			build_boolean_field()
			
			## convert boolean field to SDF by marching the parabolas
			## var SDF = boolean_to_SDF()
			## create new image texture from the SDF 
			## load that as sprite texture 
			display_new_field(bool_field)
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
	## create new SDF array and make it as big as the bool field, change bools to 0 or INF
	var new_SDF = []
	for x in bool_field.size():
		new_SDF.append([])
		for y in bool_field[x].size():
			new_SDF[x].append(null)
			if bool_field[x][y] == true:
				bool_field[x][y] = 0
			else:
				bool_field[x][y] = INF
	## consume the bool_field and populate new_SDF with distance info
	## refer to https://prideout.net/blog/distance_fields/

func display_new_field(field):
	var new_im = Image.new()
	new_im.create(field.size(), field[0].size(), false, Image.FORMAT_RGBA8)
	new_im.lock()
	for x in field.size():
		for y in field[x].size(): 
			if field[x][y] == false:
				new_im.set_pixel(x, y, Color.white)
			else:
				new_im.set_pixel(x, y, Color.black)
	new_tex = ImageTexture.new()
	new_tex.create_from_image(new_im, 1)
	new_im.unlock()
	$Sprite.texture = new_tex

func _on_HSlider_value_changed(value):
	alpha_threshold = value
