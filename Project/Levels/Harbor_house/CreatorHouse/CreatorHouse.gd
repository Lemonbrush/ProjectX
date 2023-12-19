extends BaseLevel

onready var brush_item_dispatcher = $BrushItemDispatcher

func _ready():
	var _desk_sign_connection = EventBus.connect("show_creator_house_desk_scene", self, "show_creator_house_desk_scene") 
	
func show_creator_house_desk_scene():
	brush_item_dispatcher.dispatch()
