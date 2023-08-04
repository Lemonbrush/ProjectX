extends Node
class_name BaseLevel

var pauseMenu 					= preload("res://UI/PauseMenu/PauseMenu.tscn")
var bookMenu						= preload("res://UI/BookMenu/BookMenu.tscn")

export(bool) var dynamic_camera = true

onready var player 				= find_node("Player")
onready var animationPlayer 		= $AnimationPlayer
onready var camera				= $Camera2D

######## LifeCycle ########

func _ready():
	var _connect = EventBus.connect("playerAnimationModeChange", self, "player_animation_mode_change")
	
	FileManager.current_level = get_tree().get_current_scene().get_name()
	correct_player_position_by_door()
	
	camera.follow_player = dynamic_camera
	var camera_zoom = GameEventConstants.get_constant("default_camera_zoom")
	if camera_zoom != null:
		camera.set_default_camera_zoom(camera_zoom)
	else:
		camera.set_default_camera_zoom(0.7)
	
func _unhandled_input(event):
	if event.is_action_pressed("pause_menu"):
		save_game()
		var pauseInstance = pauseMenu.instance()
		add_child(pauseInstance)
	elif event.is_action_pressed("debug_screen"):
		SettingsManager.update_debug_screen_option()
		EventBus.debug_screen_visibility_updated()
	
###### Helpers #########

func save_game():
	FileManager.save_game()
	
func correct_player_position_by_door():
	if Global.door_name:
		print(Global.door_name)
		var door_node = find_node(Global.door_name)
		if door_node && player:
			print(player.global_position, " ", door_node.global_position)
			player.global_position = door_node.global_position
			player.is_entering_out = true
			if dynamic_camera:
				camera.instant_focuse_on_target()
			
func player_animation_mode_change(isPlayerAnimating):
	get_tree().paused = isPlayerAnimating
	if isPlayerAnimating && animationPlayer:
		animationPlayer.pause_mode = Node.PAUSE_MODE_INHERIT 
	else:
		 animationPlayer.pause_mode = Node.PAUSE_MODE_PROCESS
	
func pause_level():
	get_tree().paused = true 
	
func unpouse_level():
	get_tree().paused = false
