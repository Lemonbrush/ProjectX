extends BaseLevel

onready var pedestals = $Middle_world_objects/Pedestals

func _ready():
	var _pedestals_connection = EventBus.connect("show_activate_pillars_cutscene", self, "_show_activate_pillars_cutscene")
	for pedestal in pedestals.get_children():
		var _connection = pedestal.connect("did_place_item_at_pedestal", self, "_did_place_item_at_pedestal")
	
func _did_place_item_at_pedestal():
	animationPlayer.play("Show_mystic_dweller")
	for pedestal in pedestals.get_children():
		if !pedestal.isItemPlaced:
			return
	animationPlayer.play("Show_mystic_dweller")

func _show_activate_pillars_cutscene():
	animationPlayer.play("pedestals_activation_scene")
