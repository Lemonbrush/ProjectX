extends Node2D
class_name EventManagerProtocol

export(NodePath) var eventManagerNodePath
onready var eventManager 		= get_node(eventManagerNodePath)

func registerEvent(eventTitle):
	if eventManager != null && eventManager.has_method(eventTitle):
		eventManager.call(eventTitle)
