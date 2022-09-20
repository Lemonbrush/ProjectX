extends Node2D

onready var animationPlayer = $AnimationPlayer
onready var airBeamCollisionShape = $AirBeam/Area2D/CollisionShape2D

func _ready():
	var _connection = EventBus.connect("show_create_love_potion_cut_scene", self, "show_create_love_potion_cut_scene")
	
	if GameEventConstants.constants.has("is_love_potion_created") && GameEventConstants.constants["is_love_potion_created"]:
		animationPlayer.play("Finished")
		airBeamCollisionShape.disabled = false
	else:
		airBeamCollisionShape.disabled = true

func show_create_love_potion_cut_scene():
	CommandHandler.execute("set is_love_potion_created True")
	animationPlayer.play("Show_create_potion_cut_scene")
