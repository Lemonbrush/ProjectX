extends Node2D

export(String) var dialogId
export(String) var interaction_popup_label_text = ""

onready var dialogTextBoxController = $DialogTextBoxController
onready var interactionController = $InteractionController
onready var interactionPopup = $InteractionPopup
export(bool) var is_player_interaction_active = true

func _ready():
	interactionController.is_player_interaction_active = is_player_interaction_active
	dialogTextBoxController.set_dialog_id(dialogId) 
	interactionPopup.set_label_text(interaction_popup_label_text)
	
	interactionController.connect("on_interact", self, "on_npc_interact")
	interactionController.connect("on_approach", self, "on_npc_approach")
	interactionController.connect("on_leave", self, "on_leave")

func set_player_interaction(is_active):
	is_player_interaction_active = is_active
	interactionController.is_player_interaction_active = is_active

func set_dialog_id(newDialogId: String):
	dialogId = newDialogId
	dialogTextBoxController.set_dialog_id(newDialogId) 

func on_leave():
	interactionPopup.hide()

func on_npc_approach(_body):
	interactionPopup.show()

func on_npc_interact(_interactedBody):
	interactionPopup.hide()
