extends Area2D

func _ready():
	var flower_num = (randi() % 4) + 1
	$Sprite.texture = load("res://assets/images/flower" + str(flower_num) + ".png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Flower_body_entered(body):
	if body.following:
		body.target = self.position
		body.flower = self.position
		body.following = false
		body.pollinating = true
		body._on_Bee_mouse_exited()
