extends Node

var pauseMenu 	= preload("res://UI/PauseMenu/PauseMenu.tscn")
var bookMenu	= preload("res://UI/BookMenu/BookMenu.tscn")

onready var target = get_node("Player")
export var shader_colorRect_path: NodePath
onready var shader_colorRect = get_node(shader_colorRect_path)

func _ready():
	pass
	
func _unhandled_input(event):
	if event.is_action_pressed("pause_menu"):
		var pauseInstance = pauseMenu.instance()
		add_child(pauseInstance)
	elif event.is_action_pressed("book_menu"):
		var bookInstance = bookMenu.instance()
		add_child(bookInstance)

func visual_transition_open(is_opening):
	var t = target.get_global_transform_with_canvas().origin
	if shader_colorRect != null:
		shader_colorRect.get_material().set_shader_param("target", target.get_global_transform_with_canvas().origin)
		
		$CanvasLayer/Tween.interpolate_property(
				shader_colorRect.get_material(),
				"shader_param/intensity",
				float(is_opening),
				float(not is_opening),
				1,
				Tween.TRANS_LINEAR,
				Tween.EASE_IN
				)
				
		$CanvasLayer/Tween.start()
	else:
		$CanvasLayer/CircleTransition.visible = false
