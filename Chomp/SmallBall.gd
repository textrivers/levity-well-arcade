extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	if position.y > 1000:
		queue_free()


func _on_Timer_timeout():
	sleeping = true
	set_collision_mask_bit(1, true)
