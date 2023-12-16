extends BaseLevel

onready var mysticDwellerAnimationPlayer = $CreatorHouseIsland/Middle_world_objects/Dwellers/MysticDweller
onready var redThredItemDispatcher = $Harbor_world_objects/RedThreadItemDispatcher

func _ready():
	var _red_thred_connection = EventBus.connect("show_red_thred_cutscene", self, "show_red_thred_cutscene")
	var _garden_mystic_dweller_hide = EventBus.connect("personal_garden_mystic_dweller_hide", self, "personal_garden_mystic_dweller_hide")

func show_red_thred_cutscene():
	redThredItemDispatcher.dispatch()

func personal_garden_mystic_dweller_hide():
	mysticDwellerAnimationPlayer.show_hide_animation()
