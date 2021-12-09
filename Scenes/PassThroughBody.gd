extends StaticBody2D

export(Shape2D) var shape

func _ready():
	$CollisionShape2D.shape = shape 
