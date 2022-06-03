extends CanvasLayer
signal back_pressed

onready var quitButton = $MainMarginContainer/CenterContainer/VBoxContainer/ExitButton
onready var specialOptionsButton = $MainMarginContainer/CenterContainer/VBoxContainer/SpecialOptionButton

var specialOptionsMenuScene = preload("res://UI/SpecialOptionsMenu/SpecialOptionsMenu.tscn")

func _ready():
	quitButton.connect("pressed", self, "on_quit_pressed") 
	specialOptionsButton.connect("pressed", self, "on_special_options_pressed") 
	
func on_quit_pressed():
	queue_free()
	emit_signal("back_pressed")

func on_special_options_pressed():
	var specialOptionsMenuSceneInstance = specialOptionsMenuScene.instance()
	get_tree().root.add_child(specialOptionsMenuSceneInstance)
	specialOptionsMenuSceneInstance.connect("back_pressed", self, "on_options_back_pressed")
	$MainMarginContainer.visible = false

func on_options_back_pressed():
	$MainMarginContainer.visible = true
