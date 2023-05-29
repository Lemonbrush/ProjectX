extends CanvasLayer

signal back_pressed

onready var exit_button = $MainMarginContainer/MarginContainer/VBoxContainer/MarginContainer/GameConstsList/HBoxContainer/HBoxContainer/ExitButton
onready var gameConstsList = $MainMarginContainer/MarginContainer/VBoxContainer/MarginContainer/GameConstsList
onready var textField = $MainMarginContainer/MarginContainer/VBoxContainer/MarginContainer/GameConstsList/HBoxContainer/LineEdit
onready var setButton = $MainMarginContainer/MarginContainer/VBoxContainer/MarginContainer/GameConstsList/HBoxContainer/HBoxContainer2/SetButton
onready var setFloatButton = $MainMarginContainer/MarginContainer/VBoxContainer/MarginContainer/GameConstsList/HBoxContainer/HBoxContainer2/SetFloatButton
onready var emmitButton = $MainMarginContainer/MarginContainer/VBoxContainer/MarginContainer/GameConstsList/HBoxContainer/HBoxContainer2/EmmitButton

func _ready():
	var _exit_button_connection = exit_button.connect("pressed", self, "on_quit_pressed")
	var _textField_connection = textField.connect("text_entered", self, "command_entered")
	var _const_list_update_connection = EventBus.connect("game_const_changed", self, "update_game_const_list")
	var _set_button = setButton.connect("pressed", self, "on_set_button_pressed")
	var _set_float_button = setFloatButton.connect("pressed", self, "on_set_float_button_pressed")
	var _emmit_button = emmitButton.connect("pressed", self, "on_emmit_button_pressed")
	
	update_game_const_list()
	exit_button.grab_focus()

func _unhandled_input(_event):
	if Input.is_action_just_pressed("pause_menu"):
		on_quit_pressed()

func update_game_const_list(_const = null, _value = null):
	resset_game_const_list()
	for game_const in GameEventConstants.constants:
		var value = GameEventConstants.constants[game_const]
		var button = Button.new()
		button.align = Button.ALIGN_LEFT
		button.rect_scale = Vector2(0.6,0.6)
		button.text = game_const + " " + str(value)
		button.enabled_focus_mode = Control.FOCUS_ALL
		gameConstsList.add_child(button)
		button.connect("pressed", self, "game_constant_option_pressed", [button])

func resset_game_const_list():
	for game_const_button in gameConstsList.get_children():
		if game_const_button != $MainMarginContainer/MarginContainer/VBoxContainer/MarginContainer/GameConstsList/HBoxContainer:
			gameConstsList.remove_child(game_const_button)

func command_entered(text):
	execute_command(text)
	textField.text = ""
	FileManager.save_game()
		
func on_quit_pressed():
	queue_free()
	emit_signal("back_pressed")

func game_constant_option_pressed(button):
	var args = button.text.split(" ")
	if args.size() == 2 and (args[1] == "False" or args[1] == "True"):
		autochange_bool_value_if_can(args[0], args[1])
		grab_next_button_focuse(button)
		return
	var text = button.text
	textField.text = "set_float" + " " + text
	textField.grab_focus()

func grab_next_button_focuse(button):
	var target_const = button.text.split(" ")[0]
	var is_target_button = false
	for game_const_button in gameConstsList.get_children():
		if game_const_button is Button and game_const_button.text.split(" ")[0] == target_const:
			game_const_button.grab_focus()
			return
	exit_button.grab_focus()

func autochange_bool_value_if_can(constant_name, value):
		var newValue = value
		if newValue == "False":
			newValue = "True"
		else:
			newValue = "False"
			
		var command = "set " + constant_name + " " + newValue
		execute_command(command)

func execute_command(command_line):
	CommandHandler.execute(command_line)

func update_command_with_base(base):
	var textfield_text = textField.text
	var textfield_text_parts = textfield_text.split(" ")
	if textfield_text == "" or textfield_text_parts.size() < 2:
		textField.text = base
	
	for i in len(textfield_text_parts):
		if i == 0:
			textField.text = base
		else:
			textField.text += " " + textfield_text_parts[i]

func on_set_button_pressed():
	update_command_with_base("set")

func on_set_float_button_pressed():
	update_command_with_base("set_float")

func on_emmit_button_pressed():
	update_command_with_base("emmit")
