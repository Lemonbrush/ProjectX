extends CanvasLayer

onready var label = $KissieCounter/HBoxContainer/Label
onready var heart_icon_animation_player = $KissieCounter/HBoxContainer/HeartIcon/AnimationPlayer

func _ready():
	EventBus.connect("game_const_changed", self, "update_kissie_counter_ui")
	EventBus.connect("did_reset_game_constants", self, "update_ui_data")
	update_ui_data()

func update_ui_data():
	var kissies_count = GameEventConstants.get_constant("kissies_count")
	if kissies_count != null:
		label.text = str(kissies_count)

func update_kissie_counter_ui(constant_name, value):
	if constant_name == "kissies_count":
		label.text = str(value)
		heart_icon_animation_player.play("PickupImpact")
