extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	position.y -= 20
	if position.y <= -400:
		print("despawn bullet")
		queue_free()
