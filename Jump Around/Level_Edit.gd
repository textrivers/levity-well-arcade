extends Node2D

var can_play = false
var can_save = false
var can_load = false

func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("leftclick"):
		if can_save:
			## popup list of files with text edit for filename
			## TODO serialize contents of $Hole, all positions x 1.25
			pass
		if can_play:
			## TODO load all contents of $Hole as new level? 
			pass
		if can_load:
			## TODO popup file selector 
			## TODO populate editor with contents of some file
			pass

func _on_SaveButton_mouse_entered():
	can_save = true

func _on_SaveButton_mouse_exited():
	can_save = false

func _on_PlayButton_mouse_entered():
	can_play = true

func _on_PlayButton_mouse_exited():
	can_play = false

func _on_LoadButton_mouse_entered():
	can_load = true

func _on_LoadButton_mouse_exited():
	can_load = false
