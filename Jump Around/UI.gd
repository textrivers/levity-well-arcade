extends Control

var count: int = 0
var counter
var total: int = 0
var hole_num: int = 0
var tween
var standard_course = [
	"res://Holes/Hole_0.tscn",
	"res://Holes/Hole_1.tscn",
	"res://Holes/Hole_2.tscn",
	"res://Holes/Hole_3.tscn",
	"res://Holes/Hole_4.tscn",
	"res://Holes/Hole_5.tscn",
	"res://Holes/Hole_6.tscn",
	"res://Holes/Hole_7.tscn",
	"res://Holes/Hole_8.tscn",
	"res://Holes/Hole_9.tscn",
	"res://Holes/Hole_10.tscn",
	"res://Holes/Hole_11.tscn",
	"res://Holes/Hole_12.tscn",
	"res://Holes/Hole_13.tscn",
	"res://Holes/Hole_14.tscn",
	"res://Holes/Hole_15.tscn",
	"res://Holes/Hole_16.tscn",
	"res://Holes/Hole_17.tscn"
	]
var course = []

func _ready():
	counter = $Counter
	tween = $Tween

func on_squirrel_jump():
	count += 1
	counter.text = str(count)

func on_pause_pressed():
	if get_tree().paused == false:
		get_tree().call_deferred("set_pause", true)
		$OrangeScreen.modulate.a = 0.5
		$CenterContainer.show()
		$CenterContainer/VBoxContainer/Buttons/Resume.show()
		$CenterContainer/VBoxContainer/Buttons/QuitMenu.show()
	else:
		_on_Resume_pressed()

func on_acorn_collected():
	total += count
	if hole_num < 9:
		$CenterContainer/VBoxContainer/ScoreBoxFrontNine.get_node("Box" + str(hole_num) + "/Score").text = str(count)
	else: 
		$CenterContainer/VBoxContainer/ScoreBoxBackNine.get_node("Box" + str(hole_num) + "/Score").text = str(count)
	hole_num += 1
	get_tree().set_pause(true)

func on_acorn_zoom_complete():
	count = int(0)
	counter.text = "Total = " + str(total)
	$OrangeScreen.modulate.a = 1.0
	$CenterContainer.show()
	var holes = get_tree().get_nodes_in_group("hole")
	if holes.size() > 0:
		for hole in holes:
			hole.queue_free()
	if hole_num >= course.size():
		hole_num = 0
		$CenterContainer/VBoxContainer/Buttons2/GameStart.text = "Play Again?"
		$CenterContainer/VBoxContainer/Buttons2/GameStart.show()
	else:
		$CenterContainer/VBoxContainer/Buttons/NextHole.show()
	$CenterContainer/VBoxContainer/Buttons/QuitMenu.show()
	$CenterContainer/VBoxContainer/Buttons/AimAssist.show()

func _on_PlayButton_pressed():
	hide_buttons()
	$CenterContainer/VBoxContainer/Buttons2.show()

func _on_LevelEditor_pressed():
	$CenterContainer.hide()
	$CenterContainer/VBoxContainer/Sprite.hide()
	$OrangeScreen.modulate.a = 0
	hide_buttons()
	var new_editor = load("res://Level_Edit.tscn").instance()
	new_editor.name = "Level_Edit"
	get_parent().call_deferred("add_child", new_editor)

func _on_GameStart_pressed():
	count = 0
	total = 0
	counter.text = str(count)
	counter.show()
	## build course
	if $CenterContainer/VBoxContainer/Buttons2/CustomCourse.pressed == true:
		build_custom_course()
	if course == []:
		course = standard_course
	clear_scores($CenterContainer/VBoxContainer/ScoreBoxFrontNine)
	clear_scores($CenterContainer/VBoxContainer/ScoreBoxBackNine)
	$CenterContainer/VBoxContainer/Buttons2/GameStart.text = "Start"
	$CenterContainer/VBoxContainer/Sprite.hide()
	$CenterContainer/VBoxContainer/ScoreBoxFrontNine.show()
	$CenterContainer/VBoxContainer/ScoreBoxBackNine.show()
	$CenterContainer.hide()
	$OrangeScreen.modulate.a = 0
	$Light2D/Timer.stop()
	hide_buttons()
	$CenterContainer/VBoxContainer/ItemList.hide()
	add_hole()

func _on_Resume_pressed():
	get_tree().set_pause(false)
	$OrangeScreen.modulate.a = 0
	$CenterContainer.hide()
	hide_buttons()

func _on_NextHole_pressed():
	var holes = get_tree().get_nodes_in_group("hole")
	if holes.size() > 0:
		for hole in holes:
			hole.queue_free()
	if hole_num >= course.size():
		## error checking, quit to menu
		_on_QuitMenu_pressed()
	else: 
		add_hole()
	$OrangeScreen.modulate.a = 0.0
	counter.text = str(0)
	hide_buttons()
	$CenterContainer.hide()

func add_hole():
	var new_hole = load(course[hole_num]).instance()
	get_parent().call_deferred("add_child", new_hole)
	yield(get_tree().create_timer(0.02), "timeout")
	## a few lines of hacky bullshit are just below this comment
	var assist = new_hole.get_node_or_null("Contents/Squirrel/AimAssist")
	if assist == null:
		assist = new_hole.get_node_or_null("Squirrel/AimAssist")
	if assist == null:
		get_tree().set_pause(false)
		return
	assist.visible = $CenterContainer/VBoxContainer/Buttons/AimAssist.pressed
	assist.get_node("Line2D").visible = $CenterContainer/VBoxContainer/Buttons/AimAssist.pressed
	get_tree().set_pause(false)

func _on_QuitMenu_pressed():
	get_tree().set_pause(false)
	hide_buttons()
	counter.hide()
	count = 0
	total = 0
	hole_num = 0
	course = []
	$OrangeScreen.modulate.a = 1.0
	$Light2D/Timer.start()
	var holes = get_tree().get_nodes_in_group("hole")
	if holes.size() > 0:
		for hole in holes:
			hole.queue_free()
	var editors = get_tree().get_nodes_in_group("level_edit")
	if editors.size() > 0:
		var camera = get_parent().get_node("Camera2D")
		camera.current = true
		for editor in editors:
			editor.queue_free()
	clear_scores($CenterContainer/VBoxContainer/ScoreBoxFrontNine)
	clear_scores($CenterContainer/VBoxContainer/ScoreBoxBackNine)
	$CenterContainer/VBoxContainer/Buttons2/GameStart.text = "Start"
	$CenterContainer/VBoxContainer/ScoreBoxFrontNine.hide()
	$CenterContainer/VBoxContainer/ScoreBoxBackNine.hide()
	$CenterContainer/VBoxContainer/Sprite.show()
	$CenterContainer/VBoxContainer/Buttons/AimAssist.show()
	$CenterContainer/VBoxContainer/Buttons/LevelEditor.show()
	$CenterContainer/VBoxContainer/Buttons/PlayButton.show()
	$CenterContainer/VBoxContainer/Buttons/QuitDesktop.show()
	$CenterContainer/VBoxContainer/ItemList.hide()

func _on_QuitDesktop_pressed():
	get_tree().quit()

func hide_buttons():
	var buttons = $CenterContainer/VBoxContainer/Buttons.get_children()
	for button in buttons:
		button.hide()
	$CenterContainer/VBoxContainer/Buttons2.hide()

func clear_scores(parent):
	for child in parent.get_children():
		if child.name == "Score":
			child.text = "-"
			continue
		else:
			clear_scores(child)

func _on_AimAssist_toggled(button_pressed):
	var holes = get_tree().get_nodes_in_group("hole")
	if holes.size() > 0:
		for hole in holes: 
			var assist = hole.get_node_or_null("Contents/Squirrel/AimAssist")
			if assist == null:
				assist = hole.get_node_or_null("Squirrel/AimAssist")
			assist.visible = button_pressed
			assist.get_node("Line2D").visible = button_pressed

func _on_CustomCourse_toggled(button_pressed):
	if button_pressed == false:
		course = standard_course
		$CenterContainer/VBoxContainer/ItemList.hide()
	else:
		course = []
		$CenterContainer/VBoxContainer/ItemList.clear()
		$CenterContainer/VBoxContainer/ItemList.show()
		var dir = Directory.new()
		if dir.open("user://") == OK:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if dir.current_is_dir():
					pass
				else:
					$CenterContainer/VBoxContainer/ItemList.add_item(file_name)
				file_name = dir.get_next()
		else:
			print("An error occurred when trying to access the path.")


func build_custom_course():
	if $CenterContainer/VBoxContainer/ItemList.get_selected_items().size() > 0:
		for index in $CenterContainer/VBoxContainer/ItemList.get_selected_items():
			course.append("user://" + $CenterContainer/VBoxContainer/ItemList.get_item_text(index))
	else:
		course = []
