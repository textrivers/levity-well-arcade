extends Node

var enem = preload("res://scenes/Enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused

func _on_EnemySpawnTimer_timeout():
	var new_enem = enem.instance()
	var x_range = (500 * rand_range(0, 1)) - 250
	new_enem.position.x = x_range
	new_enem.position.y = -250
	add_child(new_enem)
	$EnemySpawnTimer.wait_time = ((randi() % 5) + 1) * rand_range(0.5, 0.4)
