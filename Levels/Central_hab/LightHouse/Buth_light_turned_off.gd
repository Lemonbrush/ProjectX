extends Node2D

onready var interaction_controller = $InteractionEmitterObject

func set_active(is_active):
	visible = is_active
	interaction_controller.set_interaction_enabled(is_active)
