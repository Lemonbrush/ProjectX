extends Node2D
class_name InteractionController

enum ActionType {
	UNABLE_TO_INTERACT,
	INTERACT
}

onready var area2D = $Area2D
onready var collisionShape = $Area2D/CollisionShape2D

export(bool) var is_player_interaction_active = true
export(ActionType) var action_type = 0

signal on_approach(player, controller, body)
signal on_leave(player, controller)
signal on_interact(player, controller, body)

var interactedBody

func _ready():
	area2D.connect("body_entered", self, "_on_approach")
	area2D.connect("body_exited", self, "_on_leave")
	
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("Interaction") && action_type == 1 && interactedBody != null:
		if Global.active_interaction_controller == null:
			Global.active_interaction_controller = self
		
		if Global.active_interaction_controller == self:
			emit_signal("on_interact", interactedBody)

func _on_approach(body):
	interactedBody = body
	action_type = 1
	emit_signal("on_approach", body)
	
func _on_leave(_body):
	force_leave()

func force_leave():
	action_type = 0
	Global.active_interaction_controller = null
	emit_signal("on_leave")

func disabled(isDisabled):
	collisionShape.disabled = isDisabled
