extends RichTextLabel

var count: int = 0

func _ready():
# warning-ignore:return_value_discarded
	get_parent().get_node("Squirrel").connect("jump", self, "on_squirrel_jump")
# warning-ignore:return_value_discarded
	get_parent().get_node("Acorn").connect("acorn_collected", self, "on_acorn_collected")

func on_squirrel_jump():
	count += 1
	text = str(count)

func on_acorn_collected():
	get_tree().set_pause(true)
	$Button.show()

func _on_RichTextLabel_mouse_entered():
	$Button.show()

func _on_RichTextLabel_mouse_exited():
	$Button.hide()

func _on_Button_pressed():
	get_tree().set_pause(false)
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

func _on_Button_mouse_entered():
	$Button.show()
