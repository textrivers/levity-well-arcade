extends Area2D

export var id: int = 0
var locked = false
onready var exit = $ExitParticles

func _on_Portal_body_entered(body):
	if body.is_in_group("squirrel"):
		lock_portal()
		for dest in get_tree().get_nodes_in_group("portal"):
			if dest != self && dest.id == id && !dest.locked:
				body.global_position = dest.global_position
				body.velocity = body.velocity.length() * Vector2(cos(dest.rotation), sin(dest.rotation))
				dest.exit.emitting = true

func lock_portal():
	locked = true
	modulate = Color(0.8, 0.2, 0.2, 1)
	yield(get_tree().create_timer(0.5), "timeout")
	locked = false
	modulate = Color(1, 1, 1, 1)
