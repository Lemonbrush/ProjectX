extends Node2D

signal finished_phrase

export (AudioStreamRandomPitch) var voice_sample

onready var player = $AudioStreamPlayer

var _phrase: String = ""
var _phrase_pos: int = 0
var _phrase_wait: float = -1

var _original_pitch_scale: float
var _punctuations: Dictionary = {
	" ": 0.1,
	",": 0.2,
	".": 0.2,
	"!": 0.2,
	"?": 0.2,
}

func _ready():
	player.stream = voice_sample

func set_voice_sample(stream):
	voice_sample = stream
	player.stream = stream
	if player.stream != null:
		player.stream.random_pitch = 1.5

func play(text) -> void:
	if text is String:
		_phrase = text
		_phrase_pos = 0

func stop():
	emit_signal("finished_phrase")
	_phrase = ""

func is_reading() -> bool:
	return !!_phrase

func is_waiting() -> bool:
	return _phrase_wait > 0

# Private functions

func _process(delta: float) -> void:
	_phrase_wait -= delta
	
	if not _phrase or _phrase_wait > 0:
		return
	
	if not player.playing:
		if _phrase_pos < _phrase.length():
			
			player.play()
			_phrase_pos += 1
		else:
			stop()

func _get_distance_to_question(text: String, from_pos: int):
	var closest_question_idx: int = -1
	var symbol_idx: int = from_pos + 1
	while symbol_idx < text.length():
		if text[symbol_idx] == "?":
			closest_question_idx = symbol_idx - _phrase_pos
			break
		symbol_idx += 1
	return closest_question_idx
