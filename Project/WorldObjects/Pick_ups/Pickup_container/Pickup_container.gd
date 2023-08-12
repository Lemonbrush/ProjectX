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

func on_area_entered(body):
	if body.has_method("start_item_pickup_animation"):
		body.start_item_pickup_animation(itemScene, use_player_pick_up_scale_animation)
	EventBus.player_picked_up_item(get_name())
	pickedUp()
	queue_free()

func pickedUp():
	CommandHandler.execute("set %s %s" %[toggleGameConstant, true])

func play_view_animation(animation_name):
	if viewScene.has_method("play_animation"):
		viewScene.play_animation(animation_name)

func play_show_animation():
	if viewScene.has_method("play_show_animation"):
		viewScene.play_show_animation()
