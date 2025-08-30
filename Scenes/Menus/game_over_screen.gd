extends Control

@onready var main_menu: Button = $MainMenu
signal ReturnToMenu


func _on_main_menu_pressed() -> void:
	ReturnToMenu.emit()
