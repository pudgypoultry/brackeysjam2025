extends Node2D

signal GameOver

func trigger_game_over() -> void:
	GameOver.emit()
