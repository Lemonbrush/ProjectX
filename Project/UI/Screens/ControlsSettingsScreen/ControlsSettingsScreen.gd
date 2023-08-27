extends CanvasLayer

signal back_pressed()

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
		child.connect("did_press_rebind_key", self, "_did_press_rebind_key")

func _did_press_rebind_key(key_action):
	print(key_action)
