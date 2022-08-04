extends CanvasLayer

signal back_pressed

onready var exit_button = $MainMarginContainer/MarginContainer/VBoxContainer2/ExitButton
onready var gameConstsList = $MainMarginContainer/MarginContainer/VBoxContainer2/VBoxContainer/MarginContainer/GameConstsList
onready var textField = $MainMarginContainer/MarginContainer/VBoxContainer2/VBoxContainer/LineEdit

func _ready():
	var _exit_button_connection = exit_button.connect("pressed", self, "on_quit_pressed")
	var _textField_connection = textField.connect("text_entered", self, "command_entered")
	
	var _const_list_update_connection = EventBus.connect("game_const_changed", self, "update_game_const_list")
	
	update_game_const_list()

func _unhandled_input(_event):
	if Input.is_action_just_pressed("pause_menu"):
		on_quit_pressed()

func update_game_const_list():
	resset_game_const_list()
	for game_const in GameEventConstants.constants:
		var value = GameEventConstants.constants[game_const]
		var button = Button.new()
		button.rect_scale = Vector2(0.6,0.6)
		button.text = game_const + " " + str(value)
		gameConstsList.add_child(button)
		button.connect("pressed", self, "game_constant_option_pressed", [button])
		button.set_enabled_focus_mode(false)

func resset_game_const_list():
	for game_const_button in gameConstsList.get_children():
		gameConstsList.remove_child(game_const_button)

func command_entered(text):
	execute_command(text)
	textField.text = ""
		
func on_quit_pressed():
	queue_free()
	emit_signal("back_pressed")

func game_constant_option_pressed(button):
	var text = button.text
	textField.text = "set" + " " + text

func execute_command(command_line):
	CommandHandler.execute(command_line)
