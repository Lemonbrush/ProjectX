extends RigidBody2D
class_name PickupContainer

export(PackedScene) var itemScene
export(String) var toggleGameConstant
export(bool) var use_player_pick_up_scale_animation = true

onready var area2d			    		= $PickupArea2D
onready var visibility_notifier 		= $VisibilityNotifier2D

var viewScene

func _ready():
	area2d.connect("body_entered", self, "on_area_entered")
	
	var item_instance = itemScene.instance()
	add_child(item_instance)
	item_instance.global_position = global_position
	viewScene = item_instance

func on_area_entered(_body):
	pick_up_item()

func pick_up_item():
	EventBus.dispatch_item_to_player(toggleGameConstant, get_name(), itemScene, use_player_pick_up_scale_animation)
	queue_free()

func play_view_animation(animation_name):
	if viewScene.has_method("play_animation"):
		viewScene.play_animation(animation_name)

func play_show_animation():
	if viewScene.has_method("play_show_animation"):
		viewScene.play_show_animation()
