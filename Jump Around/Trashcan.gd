extends Area2D

var trash_closed
var trash_open

# Called when the node enters the scene tree for the first time.
func _ready():
	trash_closed = load("res://assets/images/trashcan.png")
	trash_open = load("res://assets/images/trashcanOpen.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Trashcan_area_entered(area):
	$Sprite.texture = trash_open
	area.can_trash = true

func _on_Trashcan_area_exited(area):
	$Sprite.texture = trash_closed
	area.can_trash = false
