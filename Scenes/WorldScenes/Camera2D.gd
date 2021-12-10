extends Camera2D

var targetPosition = Vector2.ZERO

export(Color, RGB) var backgroundColor

# Lifecycle Functions

func _ready():
	VisualServer.set_default_clear_color(backgroundColor)
