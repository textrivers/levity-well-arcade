extends Node2D

var target = preload("res://scenes/target.tscn")
var projectile = preload("res://scenes/projectile.tscn")
var fire_speed: float = 1.0

var num_missiles = 15

var base_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	base_pos = [ $Base.position, $Base2.position, $Base3.position, $town.position, $town2.position, $town3.position, $town4.position ]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("fire"):
		var targ = get_viewport().get_mouse_position()
		var bases = get_tree().get_nodes_in_group("base")
		var nearest = null
		var index: int = 0
		## determine which base is nearest to the mouseclick
		for base in bases:
			## exclude bases with no more missiles
			if base.missile_count <= 0:
				continue
			else:
				if index == 0:
					nearest = base
				else:
					if base.position.distance_to(targ) < nearest.position.distance_to(targ):
						nearest = base
			index += 1
		## fire a missile or not
		if nearest != null:
			nearest.fire_missile(targ)
		else:
			## TODO some user feedback indicating no more missiles
			pass
			


func _on_missile_timer_timeout():
	if num_missiles == 0:
		# TODO: level over
		return
	var missile = target.instantiate()
	var missile_spawn_location = get_node("MissilePath/MissileSpawnLocation")
	missile_spawn_location.progress_ratio = randf()
	missile.speed = fire_speed
	missile.direction = (base_pos[randi() % 7] - missile_spawn_location.position).normalized()
	#var direction = missile_spawn_location.rotation + PI / 2
	missile.position = missile_spawn_location.position
	#direction = randf_range(-PI,-2*PI)
	#missile.rotation = direction
	#print(direction)
	#var velocity = Vector2(randf_range(150.0, 150.0), 0.0)
	#missile.linear_velocity = velocity.rotated(direction)
	add_child(missile)
	num_missiles -= 1
	
