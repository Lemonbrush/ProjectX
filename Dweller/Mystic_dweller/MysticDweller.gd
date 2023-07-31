extends AbstractDweller

var mysticDwellerHideAnimation = preload("res://Dweller/Mystic_dweller/Animations/MysticDwellerHidingAnimation.tscn")
var appearParticles = preload("res://WorldObjects/Technical/MysticDwellerAppearParticles/MysticDwellerAppearParticles.tscn")

func show_hide_animation():
	animationPlayer.play("Hiding")

func place_hide_animation_scene():
	spawn_node(mysticDwellerHideAnimation)

func spawn_appear_particles():
	spawn_node(appearParticles)

func spawn_node(loadedScene):
	visible = false
	interactionController.disabled(true)
	var sceneInstance = loadedScene.instance()
	get_parent().add_child(sceneInstance)
	sceneInstance.scale = Vector2.ONE * body.scale
	sceneInstance.global_position = global_position
