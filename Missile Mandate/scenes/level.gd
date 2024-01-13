extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("fire"):
		var targ = get_viewport().get_mouse_position()
		var bases = get_tree().get_nodes_in_group("base")
		var nearest = null
		var index: int = 0
		## determine which base is nearest to the mouseclick
		for base in bases:
			## exclude bases with no more missiles
			if base.missile_count <= 0:
				continue
			else:
				if index == 0:
					nearest = base
				else:
					if base.position.distance_to(targ) < nearest.position.distance_to(targ):
						nearest = base
			index += 1
		## fire a missile or not
		if nearest != null:
			nearest.fire_missile(targ)
		else:
			## TODO some user feedback indicating no more missiles
			pass
			
