extends Node2D

export(String) var dialogId
export(String) var label_text
export (Resource) var voice_generator_configuration_file

onready var interactionPopup = $InteractionPopup
onready var interactionController = $InteractionController
onready var dialogTextBoxController = $DialogTextBoxController

func _ready():
	dialogTextBoxController.set_dialog_id(dialogId)
	dialogTextBoxController.set_letter_sounds_resource(voice_generator_configuration_file)
	interactionPopup.set_label_text(label_text)
	
	interactionController.connect("on_interact", self, "on_npc_interact")
	interactionController.connect("on_approach", self, "on_npc_approach")
	interactionController.connect("on_leave", self, "finish_talking") 
	
func on_npc_interact(_interactedBody):
	interactionPopup.hide()
	
func on_npc_approach(_body):
	interactionPopup.show()
	
func finish_talking():
	interactionPopup.hide()
