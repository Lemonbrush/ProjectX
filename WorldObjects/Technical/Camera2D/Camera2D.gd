extends Camera2D

onready var tween = $Tween
onready var screenShaker = $ScreenShaker

var targetPosition = Vector2.ZERO

export(Color, RGB) var backgroundColor

var follow_player = true

# Lifecycle Functions

func _ready():
	var _connect = EventBus.connect("cameraFocuseAnimation", self, "scale_with_animation")
	VisualServer.set_default_clear_color(backgroundColor)

func _process(delta):
	if follow_player:
		acquire_target_position()
		global_position = lerp(targetPosition, global_position, pow(2, -15 * delta))

func instant_focuse_on_target():
	acquire_target_position()
	global_position = targetPosition

func acquire_target_position():
	var acquired = get_target_position_from_node_group("player")
	if (!acquired):
		get_target_position_from_node_group("player_death")

func get_target_position_from_node_group(groupName):
	var nodes = get_tree().get_nodes_in_group(groupName)
	if (nodes.size() > 0):
		var node = nodes[0]
		targetPosition = node.global_position
		targetPosition.y -= 25
		return true
	return false
	
func scale_with_animation(newZoom, time):
	tween.stop(self)
	tween.interpolate_property(self, 'zoom', zoom, newZoom, time, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	tween.start()
	
func _screen_shake(duration = 0.2, frequency = 16, amplitude = 2, infinity = true):
	screenShaker.start(duration, frequency, amplitude, infinity)
	
func _stop_screen_shake():
	screenShaker.stop()
