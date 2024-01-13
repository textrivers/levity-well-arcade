extends Area2D

var radius = [ 15, 25, 35, 25, 15 ]
var radius_counter = 0
var collision_obj 


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(1.0).timeout
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():
	draw_circle(Vector2.ZERO, radius[radius_counter], Color.WHITE)
	collision_obj = $CollisionShape2D
	collision_obj.shape.radius = float(radius[radius_counter])


func _on_timer_timeout():
	radius_counter +=1
	var len = len(radius)
	if radius_counter >=len:
		radius_counter = 0
		queue_free()
	queue_redraw()
