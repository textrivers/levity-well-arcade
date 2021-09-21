extends Area2D

export var element_name = ""
export var scene = ""

var can_click = false
var selected = false
var dragging = false
var drag_offset: Vector2
export var source = true
var hole
var UI

var element_data = {
	"modulate": Color(0, 0, 0, 1),
	"scale": Vector2(1.0, 1.0),
	"rotation": 0.0,
	"ID": 0,
	"travel": Vector2(0, 0),
	"speed": 300, 
	"initial_delay": 1.0,
	"delay": 0.0 
}

var clone = load("res://EditorElement.tscn")

var can_trash = false

# Called when the node enters the scene tree for the first time.
func _ready():
	hole = get_parent().get_node_or_null("Hole")
	$Particles2D.texture = $Sprite.texture
	UI = get_parent().get_node("LevelEditUI")
	UI.get_node("VBoxContainer/Color/ColorPickerButton").connect("color_changed", self, "update_modulate")
	UI.get_node("VBoxContainer/Width/SpinBox").connect("value_changed", self, "update_scale")
	UI.get_node("VBoxContainer/Rotation/SpinBox").connect("value_changed", self, "update_rotation")
	UI.get_node("VBoxContainer/ID/IDSpinBox").connect("value_changed", self, "update_ID")
	UI.get_node("VBoxContainer/TravelX/SpinBox").connect("value_changed", self, "update_travelx")
	UI.get_node("VBoxContainer/TravelY/SpinBox").connect("value_changed", self, "update_travely")
	UI.get_node("VBoxContainer/Speed/SpinBox").connect("value_changed", self, "update_speed")
	UI.get_node("VBoxContainer/InitialDelay/SpinBox").connect("value_changed", self, "update_init_delay")
	UI.get_node("VBoxContainer/Delay/SpinBox").connect("value_changed", self, "update_delay")

func _process(_delta):
	if selected: 
		$Particles2D.visible = true
		## ROTATE -----------------------
		#if Input.is_action_just_pressed("rightclick"):
			#rotation += PI / 2
		#if Input.is_action_just_pressed("scroll_up"):
			#rotation += deg2rad(15)
		#if Input.is_action_just_pressed("scroll_down"):
			#rotation += deg2rad(-15)
	else:
		$Particles2D.visible = false
	
	## CLICK ------------------------
	if Input.is_action_just_pressed("leftclick"):
		if UI.mouse_over == false:
			selected = can_click
			dragging = can_click
			if can_click == true:
				if source == true:
					var new_clone = self.duplicate(7)
					get_parent().add_child(new_clone)
					source = false
					get_parent().remove_child(self)
					hole.add_child(self)
				drag_offset = (position - get_viewport().get_mouse_position())
				if selected:
					UI.call_deferred("update_display", element_data, element_name)
			var any_selected = false
			for element in get_tree().get_nodes_in_group("editorelement"):
				if element.selected == true:
					any_selected = true
			if any_selected == false:
				UI.update_display(element_data, "none")
	
	## DRAG -------------------------
	if dragging:
		modulate.a = 0.5
		position = (get_viewport().get_mouse_position() + drag_offset) 
	
	## DROP -------------------------
	if Input.is_action_just_released("leftclick"):
		if dragging:
			dragging = false
			modulate.a = 1.0
			drag_offset = Vector2()
			if element_name == "acorn":
				rotation = 0
			elif element_name == "squirrel":
				rotation = 0
				for sq in get_tree().get_nodes_in_group("ed_squirrel"):
					sq.queue_free()
				var new_squirrel = load("res://Ed_Squirrel.tscn").instance()
				new_squirrel.position = position
				get_parent().add_child(new_squirrel)
			if can_trash == true:
				call_deferred("queue_free")

func _on_EditorElement_mouse_entered():
	can_click = true

func _on_EditorElement_mouse_exited():
	can_click = false

func _on_EditorElement_area_entered(area):
	if area.is_in_group("trashcan"):
		can_trash = true

func _on_EditorElement_area_exited(area):
	if area.is_in_group("trashcan"):
		can_trash = false

func update_modulate(new_color):
	if selected:
		$Sprite.modulate = Color(new_color)
		element_data.modulate = Color(new_color)

func update_scale(new_scale):
	if selected:
		scale.x = new_scale
		element_data.scale.x = new_scale

func update_rotation(new_rot):
	if selected:
		rotation = deg2rad(new_rot)
		element_data.rotation = new_rot

func update_ID(new_ID):
	if selected:
		element_data.ID = new_ID

func update_travelx(new_travelx):
	if selected:
		element_data.travel.x = new_travelx

func update_travely(new_travely):
	if selected:
		element_data.travel.y = new_travely

func update_speed(new_speed):
	if selected:
		element_data.speed = new_speed

func update_init_delay(new_init_delay):
	if selected:
		element_data.initial_delay = new_init_delay

func update_delay(new_delay):
	if selected:
		element_data.delay = new_delay
