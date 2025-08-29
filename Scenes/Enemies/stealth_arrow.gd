extends Node2D

@onready var stealth_arrow: Node2D = $"."
@onready var ui_pivot: Node2D = $UI_pivot
@onready var stealth_ui: Node2D = $UI_pivot/StealthUI

func update_stealth_arrow(target:Vector2, stealth_percent:float) -> void:
	self.look_at(target)
	ui_pivot.global_rotation = 0
	stealth_ui.set_stealth_ui(stealth_percent)
