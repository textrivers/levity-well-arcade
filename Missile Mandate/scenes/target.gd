extends Area2D

var direction: Vector2 = Vector2.ZERO
var speed: float = 0.0
var orig_pos: Vector2 = Vector2.ZERO
var target: Vector2 = Vector2.ZERO
var frame_count: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	queue_redraw()
	## mark original position
	orig_pos = global_position
	frame_count = int(orig_pos.distance_to(target) / speed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if frame_count <= 0: 
	#	explode()
	position += direction * speed
	frame_count -= 1


func _draw():
	draw_circle(Vector2.ZERO, 3, Color.WHITE)
	$CollisionShape2D.shape.radius = float(3)

	pass


func _on_body_entered(body):
	queue_free()
	pass # Replace with function body.


func _on_area_entered(area):
	queue_free()
	pass # Replace with function body.
