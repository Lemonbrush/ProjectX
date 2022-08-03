extends Button

export(bool) var disableHoverAnim

onready var animationPlayer = $AnimationPlayer

func _ready():
	connect("mouse_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")
	connect("pressed", self, "on_pressed")
	
func _process(delta):
	rect_pivot_offset = rect_size/2

func reset_button_state():
	if (!disableHoverAnim):
		animationPlayer.play_backwards("Hover")
	
func on_mouse_entered():
	if (!disableHoverAnim):
		animationPlayer.play("Hover")

func on_pressed():
	animationPlayer.play("Hover")
	#$AudioStreamPlayer.play()

func on_focus_exited():
	reset_button_state()
