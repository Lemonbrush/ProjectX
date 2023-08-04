extends BaseLevel

func _ready():
	var _ladder_connection = EventBus.connect("show_mill_ladder_cut_scene", self, "show_mill_ladder_cut_scene")
	var _cat_nip_connection = EventBus.connect("show_cat_nip_creation_cut_scene", self, "show_cat_nip_creation_cut_scene")

func show_mill_ladder_cut_scene():
	animationPlayer.play("mill_ladder_cut_scene")
	GameEventConstants.set_constant("mill_ladder_placed", true)

func show_cat_nip_creation_cut_scene():
	animationPlayer.play("cat_nip_creation_cut_scene")
	GameEventConstants.set_constant("is_mill_gear_activated", true)
