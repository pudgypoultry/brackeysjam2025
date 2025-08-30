extends Control

@onready var start_button: Button = $StartButton
@onready var tutorial: Button = $Tutorial
@onready var credits: Button = $Credits
@onready var quit: Button = $Quit

signal StartGame
signal Tutorial
signal Credits
signal ExitGame

func _on_start_button_pressed() -> void:
	StartGame.emit()


func _on_tutorial_pressed() -> void:
	Tutorial.emit()


func _on_credits_pressed() -> void:
	Credits.emit()


func _on_quit_pressed() -> void:
	ExitGame.emit()
