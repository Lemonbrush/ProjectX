extends Camera2D

var targetPosition = Vector2.ZERO

export(Color, RGB) var backgroundColor

# Lifecycle Functions

func _ready():
	VisualServer.set_default_clear_color(backgroundColor)

func _process(delta):
	acquire_target_position()
	
	global_position = lerp(targetPosition, global_position, pow(2, -15 * delta))

# Functions

func acquire_target_position():
	get_target_position_from_node_group("player")
	
func get_target_position_from_node_group(groupName):
	var nodes = get_tree().get_nodes_in_group(groupName)
	if (nodes.size() > 0):
		var node = nodes[0]
		targetPosition = node.global_position
		return true
	return false
