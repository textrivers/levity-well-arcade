extends Area2D

signal acorn_collected
var tween
var pos_a
var pos_b
var dur: float = 1.0

export var move: bool = false
export var init_pos: Vector2
export var dest_pos: Vector2
export var duration: float

func _ready():
# warning-ignore:return_value_discarded
	self.connect("acorn_collected", get_node("/root/Room/UI"), "on_acorn_collected")
	tween = $Tween
	pos_a = global_position
	pos_b = Vector2(0, 0)
	tween.interpolate_property(self, "global_position", pos_b, pos_a, dur, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "scale", Vector2(100, 100), Vector2(1, 1), dur, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	## toggle movement animation
	if move == true:
		$AnimationPlayer.set_current_animation("move") 
		var move_anim = $AnimationPlayer.get_animation("move")
		move_anim.length = duration
		move_anim.track_set_key_value(0, 0, init_pos)
		move_anim.track_set_key_value(0, 1, dest_pos)
		move_anim.track_set_key_time(0, 1, duration / 2.0)
		move_anim.track_set_key_value(0, 2, init_pos)
		move_anim.track_set_key_time(0, 2, duration)
		$AnimationPlayer.play("move")

func _on_Acorn_body_entered(body):
	if body.is_in_group("squirrel"):
		emit_signal("acorn_collected")
		tween.connect("tween_all_completed", get_node("/root/Room/UI"), "on_acorn_zoom_complete")
		tween.interpolate_property(self, "global_position", pos_a, pos_b, dur, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.interpolate_property(self, "scale", Vector2(1, 1), Vector2(100, 100), dur, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.start()

func _on_Tween_tween_completed(_object, _key):
	if scale.x == 1:
		$CollisionShape2D.disabled = false
