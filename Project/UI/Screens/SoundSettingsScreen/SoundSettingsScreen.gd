extends CanvasLayer

signal back_pressed()

onready var popAudioPlayer = $Audio/PopRandomAudioStreamPlayer

onready var sfxOptionSlider = $MainMarginContainer/SettingsMarginContainer/ContentVBoxContainer/ButtonsVBoxContainer/SFXOptionHBoxContainer/SFXOptionHSlider
onready var sfxOptionValueLabel = $MainMarginContainer/SettingsMarginContainer/ContentVBoxContainer/ButtonsVBoxContainer/SFXOptionHBoxContainer/SFXOptionValueLabel

onready var backgroundMusicOptionSlider = $MainMarginContainer/SettingsMarginContainer/ContentVBoxContainer/ButtonsVBoxContainer/BackgroundMusicOptionVBoxContainer/BackgroundMusicOptionHSlider
onready var backgroundMusicValueLabel = $MainMarginContainer/SettingsMarginContainer/ContentVBoxContainer/ButtonsVBoxContainer/BackgroundMusicOptionVBoxContainer/BackgroundMusicValueLabel

onready var exitButton = $MainMarginContainer/SettingsMarginContainer/ContentVBoxContainer/ButtonsVBoxContainer/ExitButton

func _ready():
	configure_ui()
	exitButton.connect("pressed_and_resolved", self, "on_quit_pressed")
	sfxOptionSlider.connect("value_changed", self, "did_move_sfx_option_slider")
	backgroundMusicOptionSlider.connect("value_changed", self, "did_move_background_music_option_slider")

func did_move_sfx_option_slider(new_value):
	popAudioPlayer.play()
	sfxOptionValueLabel.text = str(new_value)
	SettingsManager.update_sfx_volume(new_value)

func did_move_background_music_option_slider(new_value):
	popAudioPlayer.play()
	backgroundMusicValueLabel.text = str(new_value)
	SettingsManager.update_background_music_volume(new_value)

func on_quit_pressed():
	queue_free()
	emit_signal("back_pressed")

func configure_ui():
	var sfx_value = SettingsManager.settings.sfx_volume
	var background_music_value = SettingsManager.settings.background_music_volume
	
	sfxOptionSlider.value = sfx_value
	backgroundMusicOptionSlider.value = background_music_value
	
	sfxOptionValueLabel.text = str(sfx_value)
	backgroundMusicValueLabel.text = str(background_music_value)
	
	exitButton.grab_focus_without_animation()
