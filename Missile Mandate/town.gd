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
	pass 
	## TODO explosion, loss of life, etc.
	queue_free()
