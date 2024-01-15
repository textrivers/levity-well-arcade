extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	queue_redraw()

func _draw():
	draw_rect(Rect2(-30, -20, 60, 40), Color.WHITE, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_entered(area):
	print("hit")
	hide()
	## TODO explosion, loss of life, etc.
	queue_free()


func _on_body_entered(body):
	print("hit")
	queue_free()
	pass # Replace with function body.
