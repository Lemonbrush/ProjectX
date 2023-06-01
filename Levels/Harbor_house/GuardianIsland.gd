extends Node2D

onready var tween = $IslandLiftTween
onready var guardianStatue = $Background_world_objects/Guardian_statue
onready var liftWaitTimer = $LiftWaitTimer
onready var cameraFocusArea = $CameraFocusArea2D

var topPosition = Vector2(103, -724)
var middlePosition = Vector2(103, -180)
var bottomPosition = Vector2(103, 85)

func _ready():
	var _lift_up_connection = guardianStatue.connect("lift_island_with_direction_up", self, "lift_island")
	var _lift_wait_timer_connection = liftWaitTimer.connect("timeout", self, "lift_island_down")
	var _tween_connection = tween.connect("tween_completed", self, "start_wait_timer_if_needed")
	var _camera_focus_area_enter_connection = cameraFocusArea.connect("body_entered", self, "camera_focus_area_entered")
	var _camera_focus_area_exit_connection = cameraFocusArea.connect("body_exited", self, "camera_focus_area_exited")
	
	if GameEventConstants.get_constant("guardian_statue_satisfied"):
		liftWaitTimer.start()

func lift_island(direction_up):
	var destination_position = topPosition if direction_up else bottomPosition
	
	if destination_position != position && !tween.is_active():
		tween.interpolate_property(self, "position", position, destination_position, 15, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
		tween.start()
	
func start_wait_timer_if_needed(_arg1, _arg2):
	if position != bottomPosition:
		liftWaitTimer.start()

func lift_island_down():
	liftWaitTimer.stop()
	if position != bottomPosition:
		tween.interpolate_property(self, "position", position, bottomPosition, 15, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
		tween.start()

func camera_focus_area_entered(body):
	if body.get_name() == "Player":
		EventBus.camera_focus_animation(1, 1)

func camera_focus_area_exited(body):
	if body.get_name() == "Player":
		EventBus.camera_focus_default_zoom(1)
