extends Area2D

export var id: int = 0
var locked = false
onready var exit = $ExitParticles
var home_color

func _ready():
	home_color = modulate

func _on_Portal_body_entered(body):
	if body.is_in_group("squirrel"):
		lock_portal()
	if body.is_in_group("portable"):
		var portals = get_tree().get_nodes_in_group("portal")
		var eligible = []
		for test in portals:
			if test != self && test.id == id && !test.locked:
				eligible.append(test)
		if eligible.size() > 0:
			var dest = eligible[randi() % eligible.size()]
			body.global_position = dest.global_position
			body.velocity = body.velocity.length() * Vector2(cos(dest.rotation), sin(dest.rotation))
			dest.exit.emitting = true
			##dest.lock_portal()

func lock_portal():
	locked = true
	modulate = Color(0.2, 0.2, 0.2, 1)
	yield(get_tree().create_timer(0.2), "timeout")
	locked = false
	modulate = home_color
