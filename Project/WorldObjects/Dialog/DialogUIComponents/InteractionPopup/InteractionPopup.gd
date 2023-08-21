extends Node2D

export(String) var labelText = ""

onready var marginNode = $MarginNode
onready var label = $MarginNode/CenterContainer/HBoxContainer/Label
onready var tween = $Tween
onready var buttonHint = $MarginNode/CenterContainer/HBoxContainer/ButtonHint
onready var show_dialog_audio_player = $Audio/ShowDialogAudioStreamPlayer

func _ready():
	buttonHint.set_hint_action("Interaction")
	modulate.a = 0.0
	label.text = labelText
	
func show(new_text = null):
	if new_text != null:
		labelText = new_text
		label.text = new_text
	
	label.text = labelText
	
	if modulate.a != 1.0:
		show_dialog_audio_player.play()
		
		marginNode.position.y = 10
		tween.stop(self)
		tween.interpolate_property(self, 'modulate:a', get_modulate().a, 1.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
		tween.interpolate_property(marginNode, 'position:y', marginNode.position.y, 0.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
		tween.start()

func hide():
	if modulate.a != 0.0:
		tween.stop(self)
		tween.interpolate_property(self, 'modulate:a', get_modulate().a, 0.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
		tween.interpolate_property(marginNode, 'position:y', marginNode.position.y, -10, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
		tween.start()

func set_label_text(label_text):
	labelText = label_text
