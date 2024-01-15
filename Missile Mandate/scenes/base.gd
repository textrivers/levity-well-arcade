extends Area2D

var missile_count: int = 15
var missile = preload("res://scenes/projectile.tscn")
var target = preload("res://scenes/target.tscn")
var fire_speed: float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	queue_redraw()

func _draw():
	draw_rect(Rect2(-30, -20, 60, 40), Color.WHITE, true)
	## draw missiles
	var count = missile_count
	var point = Vector2(-30, -20)
	for i in 3:
		if count == 0:
			break
		point.y += 10
		point.x = -30
		var row_count = min(5, count)
		count -= row_count
		while row_count > 0:
			point.x += 10
			draw_circle(point, 3, Color.BLACK)
			row_count -= 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fire_missile(target_pos):
	missile_count -= 1
	queue_redraw()
	var new_missile = missile.instantiate()
	new_missile.speed = fire_speed
	new_missile.direction = (target_pos - global_position).normalized()
	new_missile.global_position = global_position
	new_missile.target = target_pos
	add_sibling(new_missile)
	


func _on_body_entered(body):
	print("hit")
	queue_free()
	pass # Replace with function body.


func _on_area_entered(area):
	print("hit")
	queue_free()
	pass # Replace with function body.
