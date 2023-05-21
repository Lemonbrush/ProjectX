extends BaseLevel

func _ready():
	var _connection = EventBus.connect("show_activate_pillars_cutscene", self, "_show_activate_pillars_cutscene")

func _show_activate_pillars_cutscene():
	animationPlayer.play("pedestals_activation_scene")
