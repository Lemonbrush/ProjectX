extends CanvasLayer

onready var mainMarginContainer = $MainMarginContainer
onready var fpsLabel = $MainMarginContainer/VBoxContainer/FPSLabel
onready var gameVersionLabel = $MainMarginContainer/VBoxContainer/GameVersion

func _ready():
	gameVersionLabel.text = tr("version") + ":" + FileManager.get_project_version()
	
	var _connection = EventBus.connect("debug_screen_visibility_updated", self, "update_margin_visibility")
	update_margin_visibility()

func _process(_delta):
	fpsLabel.text = tr("fps") + ":" + str(Engine.get_frames_per_second())

func update_margin_visibility():
	mainMarginContainer.visible = SettingsManager.settings.is_debug_screen_active
