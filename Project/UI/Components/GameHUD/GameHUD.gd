extends CanvasLayer

onready var label = $KissieCounter/Label
onready var heart_icon_animation_player = $KissieCounter/HeartIcon/AnimationPlayer
onready var appear_animator = $KissieCounter/AppearAnimator
onready var timer = $KissieCounter/Timer

func _ready():
	var _game_const_changed_connect = EventBus.connect("game_const_changed", self, "update_kissie_counter_ui")
	var _did_reset_game_constants_connect = EventBus.connect("did_reset_game_constants", self, "update_ui_data")
	var _timeout_connect = timer.connect("timeout", self, "hide_kissies_counter")
	appear_animator.instant_hide()
	update_ui_data()

func update_ui_data():
	var kissies_count = GameEventConstants.get_constant("kissies_count")
	if kissies_count != null:
		label.text = str(kissies_count)

func update_kissie_counter_ui(constant_name, value):
	if constant_name != "kissies_count":
		return
	
	appear_animator.show()
	timer.start()
	
	if constant_name == "kissies_count":
		label.text = str(value)
		heart_icon_animation_player.play("PickupImpact")

func hide_kissies_counter():
	appear_animator.hide()
