extends Area2D

signal acorn_collected

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Acorn_body_entered(_body):
	emit_signal("acorn_collected")
