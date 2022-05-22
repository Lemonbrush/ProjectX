extends Node2D
class_name InteractionController

onready var area2D = $Area2D
onready var collisionShape = $Area2D/CollisionShape2D

enum ActionType {
	UNABLE_TO_INTERACT,
	INTERACT
}

export(ActionType) var action_type = 0

signal on_approach(player, controller)
signal on_leave(player, controller)
signal on_interact(player, controller)

func _ready():
	area2D.connect("body_entered", self, "_on_approach")
	area2D.connect("body_exited", self, "_on_leave")
	
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("Interaction") && action_type == 1:
		emit_signal("on_interact")

func _on_approach(_body):
	action_type = 1
	emit_signal("on_approach")
	
func _on_leave(_body):
	action_type = 0
	emit_signal("on_leave")
	
func disabled(isDisabled):
	collisionShape.disabled = isDisabled
