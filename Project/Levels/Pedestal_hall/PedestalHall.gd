extends BaseLevel

onready var pedestals = $Middle_world_objects/Pedestals
onready var hiddenDoorCollisionShape = $Background_world_objects/FinalLevelDoor/InteractionController/Area2D/CollisionShape2D

func _ready():
	var _pedestals_connection = EventBus.connect("show_activate_pillars_cutscene", self, "_show_activate_pillars_cutscene")
	var _door_activation_connection = EventBus.connect("show_final_level_door_opening_cutscene", self, "_show_final_level_door_opening_cutscene")
	for pedestal in pedestals.get_children():
		var _connection = pedestal.connect("did_place_item_at_pedestal", self, "_did_place_item_at_pedestal")
	update_hidden_door_state()
	
func _did_place_item_at_pedestal():
	for pedestal in pedestals.get_children():
		if !pedestal.isItemPlaced:
			return
	GameEventConstants.set_constant("did_put_all_all_items_on_pedestals", true)
	animationPlayer.play("Show_mystic_dweller")

func _show_activate_pillars_cutscene():
	animationPlayer.play("pedestals_activation_scene")

func _show_final_level_door_opening_cutscene():
	animationPlayer.play("Kissing_statues_cutscene")
	update_hidden_door_state()

func update_hidden_door_state():
	var isHiddenDoorCollisionShapeActive = GameEventConstants.get_constant("did_put_all_all_items_on_pedestals")
	hiddenDoorCollisionShape.disabled = !isHiddenDoorCollisionShapeActive

func did_finish_opening_right_door():
	GameEventConstants.set_constant("did_open_pedestal_hall_right_door", true)
