extends CanvasLayer

onready var freeTimer = $QueueFreeTimer

export var shader_colorRect_path: NodePath
onready var shader_colorRect 	= get_node(shader_colorRect_path)

onready var tween = $Tween

func _ready():
	freeTimer.connect("timeout", self, "on_timer_timeout") 

func visual_transition_open(is_opening, player):
	freeTimer.start()
	
	var _t = player.get_global_transform_with_canvas().origin
	if shader_colorRect != null:
		shader_colorRect.get_material().set_shader_param("target", player.get_global_transform_with_canvas().origin)
		
		tween.interpolate_property(
			shader_colorRect.get_material(),
			"shader_param/intensity",
			float(is_opening),
			float(not is_opening),
			1,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN
			)
				
		tween.start()
	else:
		$CircleTransition.visible = false

func on_timer_timeout():
	queue_free()
