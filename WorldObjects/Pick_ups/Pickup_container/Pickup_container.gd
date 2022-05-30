extends RigidBody2D

export(Resource) var dropResource
export(PackedScene) var itemScene

onready var area2d			= $Area2D

func _ready():
	area2d.connect("body_entered", self, "on_area_entered")
	
	var item_instance = itemScene.instance()
	add_child(item_instance)
	item_instance.global_position = global_position

func on_area_entered(body):
	if body.has_method("start_item_pickup_animation"):
		body.start_item_pickup_animation(itemScene)
	EventBus.player_picked_up_item(get_name())
	queue_free()
	
	FileManager.save_game()

func drop():
	apply_impulse(Vector2(0, 0), Vector2(0, -100))
