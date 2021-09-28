extends Panel

var mouse_over = false

var default_element_data = {
	"modulate": Color(0, 0, 0, 1),
	"scale": Vector2(1.0, 1.0),
	"rotation": 0.0,
	"id": 0,
	"travel": Vector2(0, 0),
	"speed": 300, 
	"initial_delay": 1.0,
	"delay": 0.0 
}

# Called when the node enters the scene tree for the first time.
func _ready():
	update_display(default_element_data, "none")


# warning-ignore:shadowed_variable
func update_display(element_data, element_name):
	$VBoxContainer/Color/ColorPickerButton.color = element_data["modulate"]
	$VBoxContainer/Width/SpinBox.value = element_data["scale"].x
	$VBoxContainer/Rotation/SpinBox.value = rad2deg(element_data["rotation"])
	$VBoxContainer/ID/IDSpinBox.value = element_data["id"]
	$VBoxContainer/TravelX/SpinBox.value = element_data["travel"].x
	$VBoxContainer/TravelY/SpinBox.value = element_data["travel"].y
	$VBoxContainer/Speed/SpinBox.value = element_data["speed"]
	$VBoxContainer/InitialDelay/SpinBox.value = element_data["initial_delay"]
	$VBoxContainer/Delay/SpinBox.value = element_data["delay"]
	
	match element_name:
		"acorn":
			$VBoxContainer/Description.text = "The objective of every level. Level must have at least one."
			$VBoxContainer/Color.hide()
			$VBoxContainer/Width.hide()
			$VBoxContainer/Rotation.hide()
			$VBoxContainer/ID.hide()
			$VBoxContainer/TravelX.hide()
			$VBoxContainer/TravelY.hide()
			$VBoxContainer/Speed.hide()
			$VBoxContainer/InitialDelay.hide()
			$VBoxContainer/Delay.hide()
		"squirrel":
			$VBoxContainer/Description.text = "The player character. Level must have at least one."
			$VBoxContainer/Color.hide()
			$VBoxContainer/Width.hide()
			$VBoxContainer/Rotation.hide()
			$VBoxContainer/ID.hide()
			$VBoxContainer/TravelX.hide()
			$VBoxContainer/TravelY.hide()
			$VBoxContainer/Speed.hide()
			$VBoxContainer/InitialDelay.hide()
			$VBoxContainer/Delay.hide()
		"wall":
			$VBoxContainer/Description.text = "Wall. Can be rotated, elongated, and color-changed."
			$VBoxContainer/Color.show()
			$VBoxContainer/Width.show()
			$VBoxContainer/Rotation.show()
			$VBoxContainer/ID.hide()
			$VBoxContainer/TravelX.hide()
			$VBoxContainer/TravelY.hide()
			$VBoxContainer/Speed.hide()
			$VBoxContainer/InitialDelay.hide()
			$VBoxContainer/Delay.hide()
		"moving_platform":
			$VBoxContainer/Description.text = "Moving platform. Use numbers below to specify travel parameters. Travel X and Travel Y must be positive or negative numbers, otherwise nothing happens."
			$VBoxContainer/Color.show()
			$VBoxContainer/Width.show()
			$VBoxContainer/Rotation.show()
			$VBoxContainer/ID.hide()
			$VBoxContainer/TravelX.show()
			$VBoxContainer/TravelY.show()
			$VBoxContainer/Speed.show()
			$VBoxContainer/InitialDelay.show()
			$VBoxContainer/Delay.show()
		"portal":
			$VBoxContainer/Description.text = "Portal. At least 2 portals must have matching ID numbers; otherwise nothing happens."
			$VBoxContainer/Color.show()
			$VBoxContainer/Width.hide()
			$VBoxContainer/Rotation.show()
			$VBoxContainer/ID.show()
			$VBoxContainer/TravelX.hide()
			$VBoxContainer/TravelY.hide()
			$VBoxContainer/Speed.hide()
			$VBoxContainer/InitialDelay.hide()
			$VBoxContainer/Delay.hide()
		"none":
			$VBoxContainer/Description.text = ""
			$VBoxContainer/Color.hide()
			$VBoxContainer/Width.hide()
			$VBoxContainer/Rotation.hide()
			$VBoxContainer/ID.hide()
			$VBoxContainer/TravelX.hide()
			$VBoxContainer/TravelY.hide()
			$VBoxContainer/Speed.hide()
			$VBoxContainer/InitialDelay.hide()
			$VBoxContainer/Delay.hide()

func _on_LevelEditUI_mouse_entered():
	mouse_over = true

func _on_LevelEditUI_mouse_exited():
	mouse_over = false

func _on_ColorPickerButton_pressed():
	$VBoxContainer/Color/ColorPickerButton.get_popup().mouse_filter = Control.MOUSE_FILTER_PASS
	$VBoxContainer/Color/ColorPickerButton.get_popup().rect_position = Vector2(250, -200)
	$VBoxContainer/Color/ColorPickerButton.get_popup().rect_scale = Vector2(0.8, 0.8)
