extends Node2D

export(String) var dialogId
export(String) var item_name
export(String) var interaction_popup_label_text = "Осмотреть"
export(bool) var activated = false
export(bool) var isItemPlaced = false
export(PackedScene) var itemScene

onready var animationPlayer = $AnimationPlayer
onready var dialogController = $DialogController
onready var interactionControllerCollisionShape = $InteractionController/Area2D/CollisionShape2D
onready var dialogInteractionControllerCollisionShape = $DialogController/InteractionController/Area2D/CollisionShape2D
onready var itemBaseNode = $Item

func _ready():
	var _connection = EventBus.connect("did_place_item_at_pedestal", self, "_did_place_item_at_pedestal")
	
	dialogController.set_dialog_id(dialogId)
	dialogController.interaction_popup_label_text = interaction_popup_label_text
	
	if itemScene != null:
		var item_instance = itemScene.instance()
		itemBaseNode.add_child(item_instance)
		item_instance.global_position = itemBaseNode.global_position
	
	_update_initial_animation_state()
	_update_pedestal_state()

func activate():
	activated = true
	animationPlayer.play("Activation")
	_update_pedestal_state()

func _did_place_item_at_pedestal(itemName):
	if itemName == item_name:
		isItemPlaced = true
		_update_pedestal_state()
		animationPlayer.play("ItemPlace")

func _update_pedestal_state():
	interactionControllerCollisionShape.disabled = !activated
	dialogInteractionControllerCollisionShape.disabled = !activated
	if isItemPlaced:
		interactionControllerCollisionShape.disabled = true
		dialogInteractionControllerCollisionShape.disabled = true
	itemBaseNode.visible = isItemPlaced

func _update_initial_animation_state():
	if isItemPlaced:
		animationPlayer.play("ItemPlaced")
	elif activated:
		animationPlayer.play("Activated")
	else:
		animationPlayer.play("Inactive")
