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
	"res://Holes/Hole_14.tscn"
	]
var course = []

func _ready():
	counter = $Counter
	tween = $Tween
	$CenterContainer/VBoxContainer/PopupMenu.set_as_toplevel(true)

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
		$CenterContainer/VBoxContainer/Buttons/AimAssist.show()
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
	if hole_num >= course.size():
		hole_num = 0
		var holes = get_tree().get_nodes_in_group("hole")
		if holes.size() > 0:
			for hole in holes:
				hole.queue_free()
		$CenterContainer/VBoxContainer/Buttons2/GameStart.text = "Play Again?"
		$CenterContainer/VBoxContainer/Buttons2/GameStart.show()
	else:
		$CenterContainer/VBoxContainer/Buttons/NextHole.show()
	$CenterContainer/VBoxContainer/Buttons/QuitMenu.show()
	$CenterContainer/VBoxContainer/Buttons/AimAssist.show()

func _on_PlayButton_pressed():
	_on_GameStart_pressed()
	## TODO fix this
	#hide_buttons()
	#$CenterContainer/VBoxContainer/Buttons2.show()
	## Standard course loads all 18 holes into course array
	## Select lets users choose holes to play, standard or user-created
	pass # Replace with function body.

func _on_GameStart_pressed():
	count = 0
	total = 0
	counter.text = str(count)
	counter.show()
	## build course
	if $CenterContainer/VBoxContainer/Buttons2/CustomCourse.pressed == false:
		course = standard_course
	else:
		pass
	clear_scores($CenterContainer/VBoxContainer/ScoreBoxFrontNine)
	clear_scores($CenterContainer/VBoxContainer/ScoreBoxBackNine)
	$CenterContainer/VBoxContainer/Buttons2/GameStart.text = "Start"
	$CenterContainer/VBoxContainer/Logo.hide()
	$CenterContainer/VBoxContainer/ScoreBoxFrontNine.show()
	$CenterContainer/VBoxContainer/ScoreBoxBackNine.show()
	$CenterContainer.hide()
	$OrangeScreen.modulate.a = 0
	$Light2D/Timer.start()
	hide_buttons()
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
	var assist = new_hole.get_node("Contents/Squirrel/AimAssist")
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
	$OrangeScreen.modulate.a = 1.0
	$Light2D/Timer.start()
	var holes = get_tree().get_nodes_in_group("hole")
	if holes.size() > 0:
		for hole in holes:
			hole.queue_free()
	clear_scores($CenterContainer/VBoxContainer/ScoreBoxFrontNine)
	clear_scores($CenterContainer/VBoxContainer/ScoreBoxBackNine)
	$CenterContainer/VBoxContainer/ScoreBoxFrontNine.hide()
	$CenterContainer/VBoxContainer/ScoreBoxBackNine.hide()
	$CenterContainer/VBoxContainer/Logo.show()
	$CenterContainer/VBoxContainer/Buttons/PlayButton.show()
	$CenterContainer/VBoxContainer/Buttons/QuitDesktop.show()
	$CenterContainer/VBoxContainer/Buttons/AimAssist.show()

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
			var assist = hole.get_node("Contents/Squirrel/AimAssist")
			assist.visible = button_pressed
			assist.get_node("Line2D").visible = button_pressed

func _on_CustomCourse_toggled(button_pressed):
	if button_pressed == false:
		course = standard_course
	else:
		$CenterContainer/VBoxContainer/PopupMenu.popup_centered()
