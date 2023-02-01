extends BaseLevel

onready var animation_player = $AnimationPlayer

func _ready():
	EventBus.connect("show_creator_house_desk_scene", self, "show_creator_house_desk_scene") 
	
func show_creator_house_desk_scene():
	animationPlayer.play("creator_house_desk_scene")
