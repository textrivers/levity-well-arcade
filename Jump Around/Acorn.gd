extends Area2D

signal acorn_collected

func _ready():
# warning-ignore:return_value_discarded
	self.connect("acorn_collected", get_parent().get_parent().get_parent().get_node("UI"), "on_acorn_collected")
	pass

func _on_Acorn_body_entered(_body):
	emit_signal("acorn_collected")
