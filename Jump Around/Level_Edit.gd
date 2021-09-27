extends Node2D

var can_play = false
var can_save = false
var can_load = false

func _ready():
	pass # Replace with function body.

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

func _on_Save_pressed():
	var hole_name = $InteractPanel/VBoxContainer/SaveContainer/TextEdit.text
	if hole_name == "":
		return
	var hole = load("res://Hole_Empty.tscn").instance()
	##hole.set_owner(hole)
	for element in $Hole.get_children():
		if "scene" in element:
			var el_to_save = load(element.scene).instance()
			for data in element.element_data:
				if data in el_to_save:
					el_to_save[data] = element.element_data[data]
			el_to_save.position = element.position * 1.25
			hole.add_child(el_to_save)
			el_to_save.set_owner(hole)
	var packed_scene = PackedScene.new()
	packed_scene.pack(hole)
	var saved = ResourceSaver.save(str("user://" + str(hole_name) + ".tscn"), packed_scene)
	if saved == OK:
		print("file saved!")
		$InteractPanel.hide()
		$InteractPanel/VBoxContainer/SaveContainer.hide()
		$InteractPanel/VBoxContainer/Buttons/Save.hide()
		$InteractPanel/VBoxContainer/Buttons/Exit.hide()

func _on_Exit_pressed():
		$InteractPanel.hide()
		$InteractPanel/VBoxContainer/SaveContainer.hide()
		$InteractPanel/VBoxContainer/Buttons/Save.hide()
		$InteractPanel/VBoxContainer/Buttons/Exit.hide()


func _on_SaveButton_input_event(viewport, event, shape_idx):
	if can_save:
		if event.is_action_pressed("leftclick"):
			can_save = false
			$InteractPanel.show()
			$InteractPanel/VBoxContainer/SaveContainer.show()
			$InteractPanel/VBoxContainer/Buttons/Save.show()
			$InteractPanel/VBoxContainer/Buttons/Exit.show()
