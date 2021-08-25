extends Area2D

var down_speed = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	down_speed *= rand_range(0.9, 1.0)

func _process(delta):
	position.y += down_speed
	
func _on_Enemy_area_entered(area):
	get_parent().get_node("ExplodeSound").play()
	$CollisionShape2D.call_deferred("set_disabled", true)
	if area.is_in_group("bullet"):
		area.queue_free()
		$SplatOffset.rotation_degrees = rand_range(0, 1) * 360
		$SplatOffset/Splat.visible = true
		$SplatOffset/Splat.play("splat", false)
		if randi() % 2 == 1:
			var splat2 = $Splat2
			splat2.rotation_degrees = rand_range(0, 1) * 360
			splat2.visible = true
			splat2.play("splat", false)
	if area.is_in_group("spaceship"):
		area.queue_free()

func _on_Splat_animation_finished():
	self.queue_free()
