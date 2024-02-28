extends Node
class_name BaseLevel

var pauseMenu 					= preload("res://Project/UI/Screens/PauseMenu/PauseMenu.tscn")
var bookMenu						= preload("res://Project/UI/Screens/BookMenu/BookMenu.tscn")

export (AudioStreamSample) var background_music
export(bool) var dynamic_camera = true
export(bool) var play_background_music_on_ready = true

onready var player 				= find_node("Player")
onready var animationPlayer 		= $AnimationPlayer
onready var camera				= $Camera2D
var cursor_visibility_timer = Timer.new()

######## LifeCycle ########

func _ready():
	var _connect = EventBus.connect("playerAnimationModeChange", self, "player_animation_mode_change")
	configure_file_manager()
	correct_player_position_by_door()
	configure_camera()
	configure_background_music()
	setup_mouse_visibility_timer()
	if player:
		player.save_respawn_checkpoint()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		cursor_visibility_timer.start()

func _unhandled_input(event):
	if event.is_action_pressed("pause_menu"):
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
		var door_node = find_node(Global.door_name)
		if door_node && player:
			player.global_position = door_node.global_position
			player.play_door_entering_out_action()
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

func play_background_music():
	MusicPlayer.play_stream(background_music)

func stop_background_music():
	MusicPlayer.stop()

func set_background_music_volumeDB(volumeDB):
	MusicPlayer.set_background_music_volumeDB(volumeDB)

func reset_background_music_volumeDB():
	MusicPlayer.reset_background_music_volumeDB()

func configure_background_music():
	if play_background_music_on_ready:
		play_background_music()
		MusicPlayer.reset_background_music_volumeDB()

func configure_camera():
	camera.follow_player = dynamic_camera
	var camera_zoom = GameEventConstants.get_constant("default_camera_zoom")
	if camera_zoom != null:
		camera.set_default_camera_zoom(camera_zoom)
	else:
		camera.set_default_camera_zoom(0.7)

func configure_file_manager():
	FileManager.current_level = get_tree().get_current_scene().get_name()

func setup_mouse_visibility_timer():
	cursor_visibility_timer.one_shot = true
	cursor_visibility_timer.wait_time = 1.2
	cursor_visibility_timer.connect("timeout", self, "hide_cursor")
	add_child(cursor_visibility_timer)
	cursor_visibility_timer.start()

func hide_cursor() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
