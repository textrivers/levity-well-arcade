extends Area2D

var direction: Vector2 = Vector2.ZERO
var speed: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	queue_redraw()

func _draw():
	draw_circle(Vector2.ZERO, 3, Color.WHITE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed

func _on_area_entered(area):
	explode()

func explode():
	## TODO instantiate an explosion at current location
	queue_free()
	
