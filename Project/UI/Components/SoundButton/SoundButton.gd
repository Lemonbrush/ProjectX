extends Button

onready var popAudioPlayer = $Audio/PopRandomAudioStreamPlayer
onready var hoverAudioPlayer = $Audio/HoverRandomAudioStreamPlayer

func _ready():
	var _focus_connection = connect("focus_entered", self, "on_mouse_entered")
	var _entered_connectinon = connect("mouse_entered", self, "on_mouse_entered")
	var _pressed_connectinon = connect("pressed", self, "on_pressed")
	
func on_mouse_entered():
	hoverAudioPlayer.play()

func on_pressed():
	popAudioPlayer.play()
