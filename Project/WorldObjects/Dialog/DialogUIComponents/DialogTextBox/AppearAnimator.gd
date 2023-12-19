extends Node2D

onready var appearanceTween

func _ready():
	pass 

func start_show_animation():
	appearanceTween.stop(self)
	appearanceTween.interpolate_property(self, 'modulate:a', get_modulate().a, 1.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	appearanceTween.interpolate_property(buttonHint, 'modulate:a', buttonHint.get_modulate().a, 1.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.5)
	appearanceTween.interpolate_property(marginNode, 'position:y', marginNode.position.y, 0.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	appearanceTween.start()

func start_hide_animation():
	appearanceTween.stop(self)
	appearanceTween.interpolate_property(self, 'modulate:a', get_modulate().a, 0.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	appearanceTween.interpolate_property(marginNode, 'position:y', marginNode.position.y, -10, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	appearanceTween.start()
