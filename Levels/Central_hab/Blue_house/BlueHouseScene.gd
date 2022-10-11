extends BaseLevel

onready var artwork_sprite = $ArtworkSprite

func _ready():
	artwork_sprite.visible = GameEventConstants.constants.has("artist_created_artwork") && GameEventConstants.constants["artist_created_artwork"]
