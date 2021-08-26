extends Sprite

var bee = preload("res://Bee.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func spawn_bee():
	var bee_array = []
	bee_array = get_tree().get_nodes_in_group("bee")
	if bee_array.size() < 6:
		var new_bee = bee.instance()
		new_bee.position = Vector2(20, 410)
		add_child(new_bee)
