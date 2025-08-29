extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

func set_stealth_ui(percent:float) -> void:
	var x:int = int(ceil(percent / 10) - 1)
	if x < 0:
		x = 0
	if x > 9:
		x = 9
	sprite_2d.frame = x
