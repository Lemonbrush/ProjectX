extends BaseLevel

onready var artwork_animation_player = $Artwork/AnimationPlayer
onready var artistDweller = $ArtistDweller

func _ready():
	var _art_connection = EventBus.connect("show_art_creation_cut_scene", self, "show_art_creation_cut_scene")
	var _brush_connection = EventBus.connect("show_artist_brush_gift_scene", self, "show_artist_brush_gift_scene")
	
	if GameEventConstants.constants.has("artist_created_artwork") && GameEventConstants.constants["artist_created_artwork"]:
		artistDweller.setup_custome_animation("idle_normal")
		artwork_animation_player.play("Idle")
	else:
		artwork_animation_player.play("RESET")
		artistDweller.setup_custome_animation("idle_sad")

func show_art_creation_cut_scene():
	animationPlayer.play("place_artwork_cut_scene")
	GameEventConstants.set_constant("artist_created_artwork", true)

func show_artist_brush_gift_scene():
	animationPlayer.play("artist_brush_gift_scene")
	GameEventConstants.set_constant("artist_brush_given", true)
