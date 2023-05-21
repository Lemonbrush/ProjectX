extends Node2D

onready var animationPlayer = $AnimationPlayer
onready var dialogController = $DialogController

export(String) var dialogId = ""
export(String) var interaction_popup_label_text = "Осмотреть"
export(bool) var activated = false

func _ready():
	dialogController.dialogId = dialogId
	dialogController.interaction_popup_label_text = interaction_popup_label_text

func activate():
	animationPlayer.play("Activation")
