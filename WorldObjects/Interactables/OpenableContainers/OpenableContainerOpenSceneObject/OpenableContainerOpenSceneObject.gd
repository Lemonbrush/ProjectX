extends Node2D
class_name OpenableContainerOpenSceneObject

export (PackedScene) var innerItemScene

onready var animationPlayer = $AnimationPlayer

export var isAnimationFinished = false

func _ready():
	if !isAnimationFinished:
		animationPlayer.connect("animation_finished", self, "_on_animation_finished")
		animationPlayer.play("Open")
	else:
		animationPlayer.play("Opened")
	
func drop_item():
	if innerItemScene:
		isAnimationFinished = true
		
		var innerItemSceneInstance = innerItemScene.instance()
		innerItemSceneInstance.set_position(position)

		# we have to add children to the root node in order to let them be packed in save scene
		get_tree().get_current_scene().call_deferred("add_child", innerItemSceneInstance)
		
		if innerItemSceneInstance.has_method("drop"):
			innerItemSceneInstance.call_deferred("drop")

func _on_animation_finished(_anim):
	isAnimationFinished = true
