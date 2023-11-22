extends Node
class_name InputMapper

var profile_default = {
	"up": [KEY_UP, KEY_W],
	"down": [KEY_DOWN, KEY_S],
	"left": [KEY_LEFT, KEY_A],
	"right": [KEY_RIGHT, KEY_D],
	"jump": [KEY_SPACE],
	"Interaction": [KEY_E],
	"Attack": [KEY_Z],
	"pause_menu": [KEY_ESCAPE],
	"debug_screen": [KEY_0]
}
var profile_joystic = {
	"up": [JOY_DPAD_UP],
	"down": [JOY_DPAD_DOWN],
	"left": [JOY_DPAD_LEFT],
	"right": [JOY_DPAD_RIGHT],
	"jump": [JOY_BUTTON_1],
	"Interaction": [JOY_BUTTON_2],
	"Attack": [JOY_BUTTON_3],
	"pause_menu": [JOY_BUTTON_4],
	"debug_screen": []
}
var profile = profile_default

func _ready():
	pass
	#setup_profile_dictionary()

func setup_profile_dictionary():
	var key_map_profile = SettingsManager.get_key_map_profile()
	if key_map_profile:
		profile = key_map_profile
		return
	profile = profile_default

func reset_key_map_profile():
	for action_name in profile_default.keys():
		change_action_key(action_name, profile_default[action_name])

func setup_key_map_profile():
	for action_name in profile.keys():
		change_action_key(action_name, profile[action_name])

func change_action_key(action_name, key_scancode):
	erase_action_key(action_name)

	var new_event = InputEventKey.new()
	new_event.set_scancode(key_scancode)
	InputMap.action_add_event(action_name, new_event)
	profile[action_name] = key_scancode

func erase_action_key(action_name):
	var input_events = InputMap.get_action_list(action_name)
	for event in input_events:
		InputMap.action_erase_event(action_name, event)

func save_key_profile():
	SettingsManager.save_key_profile(profile)
