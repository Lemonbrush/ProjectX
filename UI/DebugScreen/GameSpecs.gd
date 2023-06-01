extends CanvasLayer

onready var mainMarginContainer = $MainMarginContainer
onready var fpsLabel = $MainMarginContainer/SpecsVBoxContainer/GeneralVBoxContainer/FPSLabel
onready var gameVersionLabel = $MainMarginContainer/SpecsVBoxContainer/GeneralVBoxContainer/GameVersion
onready var game_consts_rich_label = $MainMarginContainer/SpecsVBoxContainer/GameConsts

func _ready():
	gameVersionLabel.text = tr("version") + ": " + FileManager.get_project_version()
	var _connection = EventBus.connect("debug_screen_visibility_updated", self, "update_margin_visibility")
	var _game_const_changed_connection = EventBus.connect("game_const_changed", self, "setup_game_consts")
	var _reset_game_consts = EventBus.connect("did_reset_game_constants", self, "setup_game_consts")
	update_margin_visibility()
	setup_game_consts()

func _process(_delta):
	fpsLabel.text = tr("fps") + ": " + str(Engine.get_frames_per_second())

func update_margin_visibility():
	mainMarginContainer.visible = SettingsManager.settings.is_debug_screen_active

func setup_game_consts(_const = null, _value = null):
	game_consts_rich_label.text = ""
	for game_const in GameEventConstants.constants:
		var value = GameEventConstants.constants[game_const]
		game_consts_rich_label.text = game_consts_rich_label.text + "\n" + game_const + "   " + str(value)
