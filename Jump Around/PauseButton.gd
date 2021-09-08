extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().call_deferred("set_pause", !get_tree().is_paused())

