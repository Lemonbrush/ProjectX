extends CanvasLayer

signal back_pressed()

onready var settings_margin_container = $MainMarginContainer/SettingsMarginContainer
onready var remap_splash_screen_container = $MainMarginContainer/RemapSplashScreenMarginContainer

onready var exit_button = $MainMarginContainer/SettingsMarginContainer/ScrollContainer/VBoxContainer/VBoxContainer2/ExitButton
onready var key_binds_container = $MainMarginContainer/SettingsMarginContainer/ScrollContainer/VBoxContainer/KeyButtonsContainer

func _ready():
	exit_button.connect("pressed_and_resolved", self, "did_press_exit_button")
	connect_key_bind_buttons()
	setup_ui()

func setup_ui():
	exit_button.grab_focus_without_animation()

func did_press_exit_button():
	queue_free()
	emit_signal("back_pressed")

func connect_key_bind_buttons():
	for child in key_binds_container.get_children():
		child.connect("did_press_rebind_key", self, "did_press_rebind_key")

func did_press_rebind_key(key_action):
	set_process_input(false)
	
	remap_splash_screen_container.open()
	var key_scancode = yield(remap_splash_screen_container, "key_selected")
	#$InputMapper.change_action_key(action_name, key_scancode)
	#line.update_key(key_scancode)
	
	set_process_input(true)
