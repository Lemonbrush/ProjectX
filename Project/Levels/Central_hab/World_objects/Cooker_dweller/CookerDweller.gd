extends Node2D

onready var animationPlayer = $AnimationPlayer
onready var airBeamCollisionShape = $AirBeam/Area2D/CollisionShape2D
onready var dweller = $AbstractDweller
onready var cauldronSteamParticles = $CauldronSteam
onready var fireParticles = $FireParticles
onready var spittingParticles = $SpittingParticles

func _ready():
	var _connection = EventBus.connect("show_create_love_potion_cut_scene", self, "show_create_love_potion_cut_scene")
	var _empty_jur_connection = EventBus.connect("show_cauldron_giving_empty_jur", self, "show_cauldron_giving_empty_jur")
	configure_scene()

func show_create_love_potion_cut_scene():
	animationPlayer.play("Show_create_potion_cut_scene")

func show_cauldron_giving_empty_jur():
	animationPlayer.play("Show_cauldron_giving_empty_jur")

func configure_scene():
	var isLovePotionCreatedConstantExists = GameEventConstants.constants.has("is_love_potion_created")
	var is_cauldron_working = isLovePotionCreatedConstantExists && GameEventConstants.get_constant("is_love_potion_created")
	set_cauldron_animation(is_cauldron_working)
		
	if GameEventConstants.is_cauldron_quest_completed():
		dweller.visible = false
		dweller.is_player_interaction_active = false

func set_cauldron_animation(is_working):
	airBeamCollisionShape.disabled = !is_working
	spittingParticles.emitting = is_working
	fireParticles.emitting = is_working
	cauldronSteamParticles.emitting = is_working
	
	if is_working:
		dweller.setup_custome_animation("Happy")
