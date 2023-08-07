extends BaseLevel

onready var itemSpawner = $Middle_world_decorations/ItemSpawner

func _ready():
	var _desk_sign_connection = EventBus.connect("show_creator_house_desk_scene", self, "show_creator_house_desk_scene") 
	
func show_creator_house_desk_scene():
	itemSpawner.spawn_item()
