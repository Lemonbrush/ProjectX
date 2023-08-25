extends CanvasLayer

signal back_pressed()

onready var sfxOptionSlider = $MainMarginContainer/SettingsMarginContainer/ContentVBoxContainer/ButtonsVBoxContainer/SFXOptionHBoxContainer/SFXOptionHSlider
onready var sfxOptionValueLabel = $MainMarginContainer/SettingsMarginContainer/ContentVBoxContainer/ButtonsVBoxContainer/SFXOptionHBoxContainer/SFXOptionValueLabel

onready var backgroundMusicOptionSlider = $MainMarginContainer/SettingsMarginContainer/ContentVBoxContainer/ButtonsVBoxContainer/BackgroundMusicOptionVBoxContainer/BackgroundMusicOptionHSlider
onready var backgroundMusicValueLabel = $MainMarginContainer/SettingsMarginContainer/ContentVBoxContainer/ButtonsVBoxContainer/BackgroundMusicOptionVBoxContainer/BackgroundMusicValueLabel

onready var exitButton = $MainMarginContainer/SettingsMarginContainer/ContentVBoxContainer/ButtonsVBoxContainer/ExitButton

func _ready():
	exitButton.connect("pressed_and_resolved", self, "on_quit_pressed")
	sfxOptionSlider.connect("value_changed", self, "did_move_sfx_option_slider")
	sfxOptionSlider.connect("drag_ended", self, "did_finish_drag_sfx_option_slider")
	backgroundMusicOptionSlider.connect("value_changed", self, "did_move_background_music_option_slider")
	backgroundMusicOptionSlider.connect("drag_ended", self, "did_finish_drag_background_music_option_slider")
	exitButton.grab_focus()

func did_finish_drag_sfx_option_slider(_value_changed):
	pass

func did_move_sfx_option_slider(new_value):
	sfxOptionValueLabel.text = str(new_value)

func did_finish_drag_background_music_option_slider(_value_changed):
	pass

func did_move_background_music_option_slider(new_value):
	backgroundMusicValueLabel.text = str(new_value)

func on_quit_pressed():
	queue_free()
	emit_signal("back_pressed")
