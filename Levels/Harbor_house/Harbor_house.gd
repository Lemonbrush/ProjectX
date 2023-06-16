extends BaseLevel

func _ready():
	var _red_thred_connection = EventBus.connect("show_red_thred_cutscene", self, "show_red_thred_cutscene")

func show_red_thred_cutscene():
	animationPlayer.play("red_thred_cutscene")
