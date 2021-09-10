extends Control

var count: int = 0
var counter

func _ready():
# warning-ignore:return_value_discarded
	get_parent().get_node("Hole/Contents/Squirrel").connect("jump", self, "on_squirrel_jump")
# warning-ignore:return_value_discarded
	get_parent().get_node("Hole/Contents/Acorn").connect("acorn_collected", self, "on_acorn_collected")
	counter = $Counter

func on_squirrel_jump():
	count += 1
	counter.text = str(count)

func on_acorn_collected():
	get_tree().set_pause(true)
	## fix this once scene transitions are possible
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	get_tree().set_pause(false)


