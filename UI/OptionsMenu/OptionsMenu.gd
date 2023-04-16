extends CanvasLayer
signal back_pressed

onready var quitButton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/OptionButtonsVBoxContainer/ExitButton
onready var specialOptionsButton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/OptionButtonsVBoxContainer/SpecialOptionButton

onready var mainMarginContainer = $MainMarginContainer
onready var menuCursor = $MenuCursor

var specialOptionsMenuScene = preload("res://UI/SpecialOptionsMenu/SpecialOptionsMenu.tscn")

func _ready():
	quitButton.connect("pressed", self, "on_quit_pressed") 
	specialOptionsButton.connect("pressed", self, "on_special_options_pressed") 

func _unhandled_input(_event):
	if Input.is_action_just_pressed("pause_menu") and mainMarginContainer.visible:
		on_quit_pressed()
		
func on_quit_pressed():
	queue_free()
	emit_signal("back_pressed")

func on_special_options_pressed():
	var specialOptionsMenuSceneInstance = specialOptionsMenuScene.instance()
	get_tree().root.add_child(specialOptionsMenuSceneInstance)
	specialOptionsMenuSceneInstance.connect("back_pressed", self, "on_options_back_pressed")
	mainMarginContainer.visible = false
	menuCursor.focuse(false)

func on_options_back_pressed():
	mainMarginContainer.visible = true
	menuCursor.focuse(true)
