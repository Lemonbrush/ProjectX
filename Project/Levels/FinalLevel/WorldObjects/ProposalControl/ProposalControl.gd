extends Control

signal she_said_yes()
signal she_said_no()

onready var yes_button = $VBoxContainer/HBoxContainer/YesButton
onready var no_button = $VBoxContainer/HBoxContainer/NoButton
onready var yes_button_shine = $VBoxContainer/HBoxContainer/YesButton/ShineParticles2D
onready var answer_button_audio_player = $Audio/AnswerButtonAudioStreamPlayer

func _ready():
	var _yes_connect = yes_button.connect("pressed", self, "she_said_yes")
	var _no_connect = no_button.connect("pressed", self, "she_said_no") 

func she_said_no():
	emit_signal("she_said_no")

func she_said_yes():
	yes_button.disabled = true
	answer_button_audio_player.play()
	yes_button_shine.emitting = true
	emit_signal("she_said_yes")
