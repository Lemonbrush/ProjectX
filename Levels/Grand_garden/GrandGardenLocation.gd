extends BaseLevel

onready var water_level_tween = $WaterSurface/Water_level_tween
onready var water_level = $WaterSurface
onready var animation_player = $AnimationPlayer
onready var left_water_tower = $World_objects/Water_tower_1
onready var right_water_tower = $World_objects/Water_tower_2
onready var left_fountains = $Fountains/Left_tower_activated_fountains
onready var right_fountains = $Fountains/Right_tower_activated_fountains
onready var cactusLoveParticles = $Upper_background_objects/Dwellers/Cactus_flower_dweller/LoveParticles
onready var young_flower_interaction_emitter = $Upper_background_objects/Young_flower/InteractionEmitterObject

var water_surface_final_phase = 566
var water_surface_second_phase = 678
var water_surface_start_phase = 873

var current_water_surface = water_surface_start_phase

func _ready():
	var _left_water_tower_connection = left_water_tower.connect("cork_destroyed_on_water_tower", self, "did_destroy_cork_on_water_tower")
	var _right_water_tower_connection = right_water_tower.connect("cork_destroyed_on_water_tower", self, "did_destroy_cork_on_water_tower")
	
	var _show_white_flower_grow_cut_scene_connection = EventBus.connect("show_white_flower_grow_cut_scene", self, "show_white_flower_grow_cut_scene")
	var _cactus_particles_connection = EventBus.connect("show_cuctus_love_particles", self, "show_cuctus_love_particles")
	
	var _young_flower_interaction_emitter_connection = young_flower_interaction_emitter.connect("interacted_with_arg", self, "did_interact_with_arg")
	
	match GameEventConstants.get_constant("grand_garden_water_level"):
		1: current_water_surface = water_surface_second_phase
		2: current_water_surface = water_surface_final_phase
	
	var active_tower_fountains = GameEventConstants.get_constant("grand_garden_water_level")
	left_fountains.visible = false
	right_fountains.visible = false
	
	if active_tower_fountains == 1.0:
		right_fountains.visible = true
	elif active_tower_fountains == 2.0:
		right_fountains.visible = true
		left_fountains.visible = true
		
func did_interact_with_arg(_arg):
	animationPlayer.play("Grand_flower_opening_cut_scene")

func did_destroy_cork_on_water_tower(tower_number):
	match tower_number:
		0: animation_player.play("left_tower_cork_animation")
		1: animation_player.play("right_tower_cork_animation")

func rise_water_level():
	match current_water_surface:
		water_surface_start_phase: 
			current_water_surface = water_surface_second_phase
			GameEventConstants.set_constant("grand_garden_water_level", 1.0)
			start_water_surface_tween_to(water_surface_second_phase)
		water_surface_second_phase: 
			current_water_surface = water_surface_final_phase
			GameEventConstants.set_constant("grand_garden_water_level", 2.0)
			start_water_surface_tween_to(water_surface_final_phase)

func start_water_surface_tween_to(next_water_surface_level):
	water_level_tween.interpolate_property(water_level, "position:y", water_level.position.y, next_water_surface_level, 3, Tween.EASE_IN, Tween.EASE_OUT)
	water_level_tween.start()

func show_white_flower_grow_cut_scene():
	animationPlayer.play("White_flower_grow_cut_scene")
	
func show_cuctus_love_particles():
	cactusLoveParticles.emitting = true

func set_grand_flower_grown_constant():
	GameEventConstants.set_constant("grand_flower_did_grow", true)