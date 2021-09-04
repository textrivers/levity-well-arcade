extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().set_pause(!get_tree().is_paused())
		print("pause pressed")


func _on_RichTextLabel_mouse_exited():
	pass # Replace with function body.
