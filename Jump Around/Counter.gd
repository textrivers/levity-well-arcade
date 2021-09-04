extends RichTextLabel

var count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().get_node("Squirrel").connect("jump", self, "on_squirrel_jump")

func on_squirrel_jump():
	count += 1
	text = str(count)

func _on_RichTextLabel_mouse_entered():
	$Button.show()

func _on_RichTextLabel_mouse_exited():
	$Button.hide()

func _on_Button_pressed():
	get_tree().reload_current_scene()

func _on_Button_mouse_entered():
	$Button.show()
