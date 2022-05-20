extends CanvasLayer

onready var play_button = $MarginContainer/VBoxContainer/PlayButton
onready var options_button = $MarginContainer/VBoxContainer/OptionsButton
onready var exit_button = $MarginContainer/VBoxContainer/ExitButton
onready var delete_ave_button = $MarginContainer/VBoxContainer/DeleteSaveButton

func _ready():
	play_button.connect("pressed", self, "on_play_pressed")
	exit_button.connect("pressed", self, "on_exit_pressed")
	delete_ave_button.connect("pressed", self, "on_save_delete_pressed")
	
func on_play_pressed():
	FileManager.load_game()
	
func on_exit_pressed():
	get_tree().quit()

func on_save_delete_pressed():
	FileManager.delete_save()
