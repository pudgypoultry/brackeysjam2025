extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

func set_slot(index:int) -> void:
	sprite_2d.frame = index % (sprite_2d.hframes * sprite_2d.vframes)
