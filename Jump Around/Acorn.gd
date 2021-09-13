extends Area2D

signal acorn_collected
var tween
var pos_a
var pos_b
var dur = 1.0

func _ready():
# warning-ignore:return_value_discarded
	self.connect("acorn_collected", get_parent().get_parent().get_parent().get_node("UI"), "on_acorn_collected")
	tween = $Tween
	pos_a = global_position
	pos_b = Vector2(0, 0)
	tween.interpolate_property(self, "global_position", pos_b, pos_a, dur, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "scale", Vector2(100, 100), Vector2(1, 1), dur, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func _on_Acorn_body_entered(body):
	if body.is_in_group("squirrel"):
		emit_signal("acorn_collected")
		tween.connect("tween_all_completed", get_parent().get_parent().get_parent().get_node("UI"), "on_acorn_zoom_complete")
		tween.interpolate_property(self, "global_position", pos_a, pos_b, dur, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.interpolate_property(self, "scale", Vector2(1, 1), Vector2(100, 100), dur, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.start()

func _on_Tween_tween_completed(_object, _key):
	if scale.x == 1:
		$CollisionShape2D.disabled = false
