extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Beehive_body_entered(body):
	if body.following:
		body.target = self.position
		body.following = false
		body._on_Bee_mouse_exited()
