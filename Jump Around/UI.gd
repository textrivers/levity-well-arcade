extends Control

var count: int = 0
var counter
var total: int = 0
var hole_num: int = 0
var tween
var course_size: int = 9

func _ready():
	counter = $Counter
	tween = $Tween

func on_squirrel_jump():
	count += 1
	counter.text = str(count)

func on_pause_pressed():
	if get_tree().paused == false:
		get_tree().set_pause(true)
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
	if hole_num >= course_size:
		hole_num = 0
		var holes = get_tree().get_nodes_in_group("hole")
		if holes.size() > 0:
			for hole in holes:
				hole.queue_free()
		$CenterContainer/VBoxContainer/Buttons/GameStart.text = "Play Again?"
		$CenterContainer/VBoxContainer/Buttons/GameStart.show()
	else:
		$CenterContainer/VBoxContainer/Buttons/NextHole.show()
	$CenterContainer/VBoxContainer/Buttons/QuitMenu.show()
	$CenterContainer/VBoxContainer/Buttons/AimAssist.show()

func _on_GameStart_pressed():
	count = 0
	total = 0
	counter.text = str(count)
	counter.show()
	clear_scores($CenterContainer/VBoxContainer/ScoreBoxFrontNine)
	clear_scores($CenterContainer/VBoxContainer/ScoreBoxBackNine)
	$CenterContainer/VBoxContainer/Buttons/GameStart.text = "Start Game"
	$CenterContainer/VBoxContainer/Logo.hide()
	$CenterContainer/VBoxContainer/ScoreBoxFrontNine.show()
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
	if hole_num >= course_size:
		## error checking, quit to menu
		_on_QuitMenu_pressed()
	else: 
		add_hole()
	$OrangeScreen.modulate.a = 0.0
	counter.text = str(0)
	hide_buttons()
	$CenterContainer.hide()

func add_hole():
	var new_hole = load("res://Hole_" + str(hole_num) + ".tscn").instance()
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
	$CenterContainer/VBoxContainer/Buttons/GameStart.show()
	$CenterContainer/VBoxContainer/Buttons/QuitDesktop.show()
	$CenterContainer/VBoxContainer/Buttons/AimAssist.show()

func _on_QuitDesktop_pressed():
	get_tree().quit()

func hide_buttons():
	var buttons = $CenterContainer/VBoxContainer/Buttons.get_children()
	for button in buttons:
		button.hide()

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
