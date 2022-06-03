extends CanvasLayer
signal back_pressed

onready var quitButton = $MarginContainer2/CenterContainer/VBoxContainer/ExitButton
onready var deleteAllSavesButton = $MarginContainer2/CenterContainer/VBoxContainer/ButtonsVBoxContainer/DeleteAllSavesButton

func _ready():
	quitButton.connect("pressed", self, "on_quit_pressed") 
	deleteAllSavesButton.connect("pressed", self, "on_save_delete_pressed") 

func on_quit_pressed():
	queue_free()
	emit_signal("back_pressed")

func on_save_delete_pressed():
	deleteAllSavesButton.disabled = true
	FileManager.delete_save()
