extends BaseLevel

func _ready():
	var _connection = EventBus.connect("show_lighthouse_key", self, "show_lighthouse_key")

func show_lighthouse_key():
	animationPlayer.queue("show_lighthouse_key_cut_scene")
