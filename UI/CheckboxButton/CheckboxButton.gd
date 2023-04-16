extends HBoxContainer
signal pressed()

onready var checkbox = $Checkbox

func _ready():
	var _connection = checkbox.connect("pressed", self, "did_press")

func setup_checkbox(is_pressed):
	checkbox.pressed = is_pressed

func did_press():
	emit_signal("pressed")
