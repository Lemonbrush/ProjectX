extends CanvasLayer
signal back_pressed

onready var quitButton = $MainMarginContainer/MarginContainer/MenuVBoxContainer/ExitButton
onready var mainMarginContainer = $MainMarginContainer
onready var textLabel = $MainMarginContainer/MarginContainer/MenuVBoxContainer/RichTextLabel

func _ready():
	quitButton.connect("pressed", self, "on_quit_pressed")
	textLabel.text = load_file("res://ProjectResources/CHANGELOG.md")

func _unhandled_input(_event):
	if Input.is_action_just_pressed("pause_menu") and mainMarginContainer.visible:
		on_quit_pressed()
		
func on_quit_pressed():
	queue_free()
	emit_signal("back_pressed")

func load_file(file):
	var f = File.new()
	
	if not f.file_exists(file):
		print("No file saved!")
		return "empty"
	
	if f.open(file, File.READ) != 0:
		print("Error opening file")
		return "empty"
		
	return f.get_as_text()
