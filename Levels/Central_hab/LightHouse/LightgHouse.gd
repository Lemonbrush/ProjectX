extends BaseLevel

onready var buth_ladder = $MiddleWorldObjects/LightButhLadder
onready var buth_ladder_area_shape = $MiddleWorldObjects/LightButhLadder/Ladder5/CollisionShape2D
onready var lamp_interaction_controller = $MiddleWorldObjects/Buth_light_turned_off/InteractionEmitterObject
onready var buth_light_turned_on = $MiddleWorldObjects/Buth_light_turned_on
onready var buth_light_turned_off = $MiddleWorldObjects/Buth_light_turned_off

func _ready():
	var _connection = lamp_interaction_controller.connect("interacted_with_arg", self, "did_inetacted_with_lamp")
	configure_buth_ladder()
	configure_lamp_sprite()

func configure_buth_ladder():
	var buth_ladder_const = GameEventConstants.get_constant("lighthouse_lamp_ladder_placed")
	if buth_ladder_const != null:
		buth_ladder.visible = buth_ladder_const
		buth_ladder_area_shape.disabled = !buth_ladder_const

func configure_lamp_sprite():
	var lamp_ignited_const = GameEventConstants.get_constant("player_ignited_lighthouse_lamp")
	if lamp_ignited_const == null:
		return
	buth_light_turned_off.set_active(!lamp_ignited_const)
	buth_light_turned_on.set_active(lamp_ignited_const)

func did_inetacted_with_lamp(_arg):
	animationPlayer.play("Lamp_ignition_cutscene")
