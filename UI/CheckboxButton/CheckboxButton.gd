extends HBoxContainer
signal pressed()

export (bool) var pressed = false

onready var checkbox = $Checkbox

func _ready():
	var _connection = checkbox.connect("pressed", self, "emit_pressed")
	checkbox.pressed = pressed

func setup_checkbox(is_pressed):
	checkbox.pressed = is_pressed

func did_press():
	emit_signal("pressed")
	checkbox.pressed = !checkbox.pressed

func emit_pressed():
	emit_signal("pressed")
