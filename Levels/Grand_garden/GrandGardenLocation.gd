extends BaseLevel

onready var water_level_tween = $WaterSurface/Water_level_tween
onready var water_level = $WaterSurface
onready var animation_player = $AnimationPlayer
onready var left_water_tower = $World_objects/Water_tower_1
onready var right_water_tower = $World_objects/Water_tower_2

var water_surface_final_phase = 566
var water_surface_second_phase = 678
var water_surface_start_phase = 873

var current_water_surface = water_surface_start_phase

func _ready():
	left_water_tower.connect("cork_destroyed_on_water_tower", self, "did_destroy_cork_on_water_tower")
	right_water_tower.connect("cork_destroyed_on_water_tower", self, "did_destroy_cork_on_water_tower")
	
	EventBus.connect("show_white_flower_grow_cut_scene", self, "show_white_flower_grow_cut_scene")
	
	match GameEventConstants.get_constant("grand_garden_water_level"):
		1: current_water_surface = water_surface_second_phase
		2: current_water_surface = water_surface_final_phase

func did_destroy_cork_on_water_tower(tower_number):
	match tower_number:
		0: animation_player.play("left_tower_cork_animation")
		1: animation_player.play("right_tower_cork_animation")

func rise_water_level():
	var next_water_surface_level
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
