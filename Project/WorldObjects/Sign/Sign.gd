extends Node2D

export(String) var dialogId

onready var dialogObject = $AbstractDialogInteractionObject

func _ready():
	dialogObject.set_dialog_id(dialogId)
