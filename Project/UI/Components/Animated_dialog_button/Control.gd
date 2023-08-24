extends Button

signal pressed_and_resolved()

export(bool) var disableHoverAnim

onready var animationPlayer = $AnimationPlayer

func _ready():
	var _focus_connection = connect("focus_entered", self, "on_mouse_entered")
	var _entered_connectinon = connect("mouse_entered", self, "on_mouse_entered")
	var _pressed_connectinon = connect("pressed", self, "on_pressed")
	
func _process(_delta):
	rect_pivot_offset = rect_size/2
	
func on_mouse_entered():
	if (!disableHoverAnim):
		animationPlayer.play("Hover")

func on_pressed():
	animationPlayer.play("Press")

func grab_focus_without_animation():
	disableHoverAnim = true
	grab_focus()
	disableHoverAnim = false

func did_finish_press_animation():
	emit_signal("pressed_and_resolved")
