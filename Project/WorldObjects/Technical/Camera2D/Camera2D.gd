extends Camera2D

onready var tween = $Tween
onready var screenShaker = $ScreenShaker

var targetPosition = Vector2.ZERO
var default_camera_speed = -5
var current_camera_speed = default_camera_speed

export(Color, RGB) var backgroundColor
export(bool) var zoom_based_on_editor_value = false
export(float) var default_zoom = 0.7
export(bool) var follow_player = true
export(float) var default_y_offset = 40.0
export(float) var y_offset = 40.0

var target_node_group_name

func _ready():
	var _focus_const_change_connection = EventBus.connect("game_const_changed", self, "on_game_const_changed")
	var _connect = EventBus.connect("camera_focus_animation", self, "scale_with_animation")
	var _default_zoom_connection = EventBus.connect("camera_focus_default_zoom", self, "scale_to_default_zoom_with_animation")
	var _set_y_offset = EventBus.connect("camera_set_y_offset", self, "camera_set_y_offset")
	var _set_default_y_offset = EventBus.connect("camera_set_default_y_offset", self, "camera_set_default_y_offset")
	var _focus_connection = EventBus.connect("focus_camera_on_group_node_named", self, "focus_camera_on_group_node_named")
	var _focus_reset_connection = EventBus.connect("reset_camera_focus", self, "reset_camera_focus")
	
	VisualServer.set_default_clear_color(backgroundColor)
	reset_target_node_group_name()

func _process(_delta):
	if follow_player:
		acquire_target_position()
		global_position = targetPosition

func instant_focuse_on_target():
	smoothing_enabled = false
	global_position = targetPosition
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	smoothing_enabled = true

func acquire_target_position():
	var acquired = get_target_position_from_node_group(target_node_group_name)
	if (!acquired):
		get_target_position_from_node_group("player_death")

func get_target_position_from_node_group(groupName):
	var nodes = get_tree().get_nodes_in_group(groupName)
	if (nodes.size() > 0):
		var node = nodes[0]
		targetPosition = node.global_position
		targetPosition.y -= y_offset
		return true
	return false
	
func scale_with_animation(newZoom, time):
	tween.stop(self)
	tween.interpolate_property(self, 'zoom', zoom, Vector2(newZoom, newZoom), time, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	tween.start()

func scale_to_default_zoom_with_animation(time = 1):
	scale_with_animation(default_zoom, time)

func set_default_camera_zoom(zoomValue):
	if zoom_based_on_editor_value:
		return
	
	default_zoom = zoomValue
	zoom.x = zoomValue
	zoom.y = zoomValue

func on_game_const_changed(constant_name, value):
	if constant_name == "default_camera_zoom":
		set_default_camera_zoom(value)
	
func _screen_shake(duration = 0.2, frequency = 16, amplitude = 2, infinity = true):
	screenShaker.start(duration, frequency, amplitude, infinity)
	
func _stop_screen_shake():
	screenShaker.stop()

func camera_set_y_offset(new_offset):
	y_offset = new_offset

func camera_set_default_y_offset():
	y_offset = default_y_offset

func set_target_node_group_name(name):
	target_node_group_name = name

func reset_target_node_group_name():
	target_node_group_name = "player"

func focus_camera_on_group_node_named(new_target_name):
	set_target_node_group_name(new_target_name)

func reset_camera_focus():
	reset_target_node_group_name()
