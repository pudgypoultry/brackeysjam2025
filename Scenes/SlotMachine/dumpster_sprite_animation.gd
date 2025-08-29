extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_anim() -> void:
	animation_player.play("dumpster_dive")
