extends Area2D

signal acorn_collected

func _on_Acorn_body_entered(_body):
	emit_signal("acorn_collected")
