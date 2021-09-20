extends Area2D

export var element_name = ""
export var scene = ""

var can_click = false
var selected = false
var dragging = false
var drag_offset: Vector2
export var source = true
var hole

var element_data = {
	"scale": Vector2(1.0, 1.0),
	"rotation": 0.0,
	"modulate": Color(0, 0, 0, 1),
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

func _process(_delta):
	if selected: 
		## TODO visual feedback for user
		$Particles2D.visible = true
		## ROTATE -----------------------
		if Input.is_action_just_pressed("rightclick"):
			rotation += PI / 2
		if Input.is_action_just_pressed("scroll_up"):
			rotation += deg2rad(15)
		if Input.is_action_just_pressed("scroll_down"):
			rotation += deg2rad(-15)
	else:
		$Particles2D.visible = false
	
	## CLICK ------------------------
	if Input.is_action_just_pressed("leftclick"):
		if can_click == true:
			if source == true:
				var new_clone = self.duplicate(7)
				get_parent().add_child(new_clone)
				source = false
				get_parent().remove_child(self)
				hole.add_child(self)
			drag_offset = (position - get_viewport().get_mouse_position())
		dragging = can_click
		selected = can_click
		## TODO send or retrieve element data to/from UI
	
	## DRAG -------------------------
	if dragging:
		modulate = Color(1, 1, 1, 0.5)
		position = (get_viewport().get_mouse_position() + drag_offset) 
	
	## DROP -------------------------
	if Input.is_action_just_released("leftclick"):
		if dragging:
			dragging = false
			modulate = Color(1, 1, 1, 1)
			drag_offset = Vector2()
			if element_name == "Acorn":
				rotation = 0
			elif element_name == "Squirrel":
				modulate = Color(1, 1, 1, 0.5)
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
	print(can_click)

func _on_EditorElement_mouse_exited():
	can_click = false
	print(can_click)

func _on_EditorElement_area_entered(area):
	if area.is_in_group("trashcan"):
		can_trash = true

func _on_EditorElement_area_exited(area):
	if area.is_in_group("trashcan"):
		can_trash = false
