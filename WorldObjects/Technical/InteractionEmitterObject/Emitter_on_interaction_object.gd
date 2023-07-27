extends Node2D

signal interacted_with_arg(arg)

export(String) var emitting_arg
export(String) var labelText = ""
export(bool) var is_interaction_enabled = true

onready var interactionPopup = $InteractionPopup
onready var interactionController = $InteractionController

func _ready():
	interactionController.connect("on_approach", self, "on_player_entered")
	interactionController.connect("on_interact", self, "on_player_interacted")
	interactionController.connect("on_leave", self, "on_player_leave")
	if !labelText.empty():
		interactionPopup.set_label_text(labelText)

func on_player_entered(_body):
	if is_interaction_enabled:
		interactionPopup.show()
	
func on_player_interacted(_body):
	if is_interaction_enabled:
		interactionPopup.hide()
		emit_signal("interacted_with_arg", emitting_arg)
	
func on_player_leave():
	interactionPopup.hide()

func set_interaction_enabled(is_enabled):
	is_interaction_enabled = is_enabled
	if !is_enabled:
		interactionPopup.force_leave()

func force_check_body_detector():
	interactionController.force_check_entered_body()
