extends KinematicBody2D

export var rot_speed: float = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	rotate(rot_speed)
