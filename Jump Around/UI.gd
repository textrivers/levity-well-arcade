extends Control

var count: int = 0
var counter
var hole_num = 0

func _ready():
# warning-ignore:return_value_discarded
	#get_parent().get_node("Hole/Contents/Squirrel").connect("jump", self, "on_squirrel_jump")
# warning-ignore:return_value_discarded
	#get_parent().get_node("Hole/Contents/Acorn").connect("acorn_collected", self, "on_acorn_collected")
	counter = $Counter

func on_squirrel_jump():
	count += 1
	counter.text = str(count)

func on_acorn_collected():
	count = int(0)
	counter.text = str(0)
	hole_num += 1
	get_tree().set_pause(true)
	## fix this once scene transitions are possible
# warning-ignore:return_value_discarded
	##get_tree().reload_current_scene()
	var holes = get_tree().get_nodes_in_group("hole")
	for hole in holes:
		hole.queue_free()
	var new_hole = load("res://Hole_" + str(hole_num) + ".tscn").instance()
	get_parent().call_deferred("add_child", new_hole)
	get_tree().set_pause(false)


