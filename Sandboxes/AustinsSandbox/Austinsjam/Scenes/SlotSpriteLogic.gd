extends Node2D
@onready var slotsprite:Sprite2D = $Sprite2D

func _setsprite(index:int)-> void:
	slotsprite.frame = index %(slotsprite.hframes*slotsprite.vframes)
	
