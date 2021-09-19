extends Area2D

export var element_name = ""
export var scene = ""

var can_click = false
var selected = false
var dragging = false
var drag_offset: Vector2
var source = true
var hole

var clone = load("res://EditorElement.tscn")

var can_trash = false

# Called when the node enters the scene tree for the first time.
func _ready():
	hole = get_parent().get_node("Hole")


func _process(_delta):
	if selected: 
		## TODO visual feedback for user
		pass
		## ROTATE -----------------------
		if Input.is_action_just_pressed("rightclick"):
			rotation += PI / 2
	
	## CLICK ------------------------
	if Input.is_action_just_pressed("leftclick"):
		if can_click == true:
			if source == true:
				var new_clone = clone.instance()
				new_clone.position = position
				new_clone.element_name = element_name
				new_clone.scene = scene
				new_clone.get_node("Sprite").texture = $Sprite.texture
				new_clone.get_node("CollisionShape2D").shape = $CollisionShape2D.shape
				get_parent().add_child(new_clone)
				source = false
				get_parent().remove_child(self)
				hole.add_child(self)
			drag_offset = (position - get_viewport().get_mouse_position())
		dragging = can_click
		selected = can_click
	
	## DRAG -------------------------
	if dragging:
		$Sprite.modulate = Color(1, 1, 1, 0.5)
		position = (get_viewport().get_mouse_position() + drag_offset) 
	
	## DROP -------------------------
	if Input.is_action_just_released("leftclick"):
		dragging = false
		$Sprite.modulate = Color(1, 1, 1, 1)
		drag_offset = Vector2()
		if element_name == "Acorn":
			rotation = 0
		if can_trash == true:
			call_deferred("queue_free")

func _on_EditorElement_mouse_entered():
	can_click = true

func _on_EditorElement_mouse_exited():
	can_click = false

func _on_EditorElement_area_entered(area):
	if area.is_in_group("trashcan"):
		can_trash = true
		print(can_trash)

func _on_EditorElement_area_exited(area):
	if area.is_in_group("trashcan"):
		can_trash = false
		print(can_trash)
