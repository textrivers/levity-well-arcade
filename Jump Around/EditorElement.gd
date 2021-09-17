extends Area2D

export var element_name = ""
export var scene = ""

var can_click = false
var selected = false
var dragging = false
var drag_offset: Vector2
var source = true

var clone = load("res://EditorElement.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	if selected: 
		## TODO visual feedback for user
		pass
		## ROTATE -----------------------
		if Input.is_action_just_pressed("rightclick"):
			rotation += PI / 2
	
	## CLICK ------------------------
	if Input.is_action_just_pressed("leftclick"):
		if source == true:
			var new_clone = clone.instance()
			new_clone.position = position
			new_clone.element_name = element_name
			new_clone.scene = scene
			new_clone.get_node("Sprite").texture = $Sprite.texture
			new_clone.get_node("CollisionShape2D").shape = $CollisionShape2D.shape
			get_parent().add_child(new_clone)
			source = false
		selected = can_click
		dragging = can_click
		drag_offset = position - get_viewport().get_mouse_position()
	
	## DRAG -------------------------
	if dragging:
		$Sprite.modulate = Color(1, 1, 1, 0.5)
		position = get_viewport().get_mouse_position() + drag_offset
	
	## DROP -------------------------
	if Input.is_action_just_released("leftclick"):
		dragging = false
		$Sprite.modulate = Color(1, 1, 1, 1)
		drag_offset = Vector2()
		if position.x < 308.5 && position.x > 492:
			if position.y > -180 && position.y < 280:
				## TODO drop & reparent to Hole
				pass
	
	

func _on_EditorElement_mouse_entered():
	can_click = true

func _on_EditorElement_mouse_exited():
	can_click = false
