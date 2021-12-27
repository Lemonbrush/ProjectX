extends CanvasLayer

onready var animation_player 	= $AnimationPlayer
onready var cancel_button		= $MarginContainer/MarginContainer/Cancel

func _ready():
	get_tree().paused = true 
	cancel_button.connect("pressed", self, "on_cancel_pressed")
	
	
func _unhandled_input(event):
	if event.is_action_pressed("pause_menu"):
		unpause()
		get_tree().set_input_as_handled()
		
func unpause():
	queue_free()
	get_tree().paused = false
	
func on_cancel_pressed():
	unpause()
