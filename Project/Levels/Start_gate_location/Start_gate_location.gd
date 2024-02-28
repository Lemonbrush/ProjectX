extends BaseLevel

onready var lonelyDweller = $MiddleWorldObjects/NPC/LonelyDweller
onready var mysticDwellerAppearTriggerArea2D = $MiddleWorldObjects/NPC/FirstMysticDwellerEncounering/MysticDwellerAppearTriggerArea2D

func _ready():
	var _success = EventBus.connect("player_picked_up_item", self, "_on_key_item_collected")
	if mysticDwellerAppearTriggerArea2D:
		var _mysticDwellerAppearTrigger = mysticDwellerAppearTriggerArea2D.connect("body_entered", self, "player_did_encounter_mystic_dweller")
	var _did_finish_mystic_dweller_dialog = EventBus.connect("did_finish_the_first_mystic_dweller_dialog", self, "did_finish_the_first_mystic_dweller_dialog")
	
	if GameEventConstants.is_cauldron_quest_completed():
		lonelyDweller.visible = false
	
	if GameEventConstants.get_constant("is_start_gate_first_entrance"):
		GameEventConstants.set_constant("is_start_gate_first_entrance", false)
		animationPlayer.play("First_entrance_animation")
	else:
		play_background_music()

func _on_key_item_collected(item_name):
	if item_name == "HeartKeyItem":
		animationPlayer.queue("Gate_opening_cut_scene")

func player_did_encounter_mystic_dweller(_body):
	if GameEventConstants.get_constant("did_encounter_mystic_dweller_the_first_time") == false :
		GameEventConstants.set_constant("did_encounter_mystic_dweller_the_first_time", true)
		animationPlayer.play("Mystic_dweller_first_encounterance")

func did_finish_the_first_mystic_dweller_dialog():
	animationPlayer.play("Finish_mystic_dweller_first_dialog")
