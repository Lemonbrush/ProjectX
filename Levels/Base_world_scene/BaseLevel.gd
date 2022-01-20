extends Node

var pauseMenu 					= preload("res://UI/PauseMenu/PauseMenu.tscn")
var bookMenu						= preload("res://UI/BookMenu/BookMenu.tscn")

onready var player 				= get_node("Player")
export var shader_colorRect_path: NodePath
onready var shader_colorRect 	= get_node(shader_colorRect_path)

onready var animationPlayer 		= $AnimationPlayer
onready var page_collectable 	= $Collectables/Page

######## LifeCycle ########

func _ready():
	FileManager.current_level = get_tree().get_current_scene().get_name()
	FileManager.load_game()
	correct_player_position_by_door()
	visual_transition_open(false)
	
	page_collectable.connect("page_collected", self, "on_page_collected")
	
func _unhandled_input(event):
	if event.is_action_pressed("pause_menu"):
		var pauseInstance = pauseMenu.instance()
		add_child(pauseInstance)
	elif event.is_action_pressed("book_menu"):
		var bookInstance = bookMenu.instance()
		add_child(bookInstance)

######## Intro Animation Logic ########

func visual_transition_open(is_opening):
	var _t = player.get_global_transform_with_canvas().origin
	if shader_colorRect != null:
		shader_colorRect.get_material().set_shader_param("target", player.get_global_transform_with_canvas().origin)
		
		$IntroAnimationShader/Tween.interpolate_property(
				shader_colorRect.get_material(),
				"shader_param/intensity",
				float(is_opening),
				float(not is_opening),
				1,
				Tween.TRANS_LINEAR,
				Tween.EASE_IN
				)
				
		$IntroAnimationShader/Tween.start()
	else:
		$IntroAnimationShader/CircleTransition.visible = false

###### Level Events Logic #########

func on_page_collected():
	animationPlayer.play("Gate_opening_cut_scene")
	
###### Helpers #########

func save_game():
	FileManager.save_game()
	
func correct_player_position_by_door():
	print("Going fing ", Global.door_name)
	if Global.door_name:
		var door_node = find_node(Global.door_name)
		if door_node:
			print("Position corrected")
			player.global_position = door_node.global_position
