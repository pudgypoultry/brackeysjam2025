extends Node2D

const GAME_START_SCREEN = preload("res://Scenes/Menus/game_start_screen.tscn")
const GAME_OVER_SCREEN = preload("res://Scenes/Menus/game_over_screen.tscn")
const PROTOTYPE_SCENE = preload("res://Prototype/PrototypeScene.tscn")
var start_menu:Node
var game:Node
var game_over:Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_start_menu()
	
func load_start_menu() -> void:
	# add start menu
	start_menu = GAME_START_SCREEN.instantiate()
	get_tree().root.add_child.call_deferred(start_menu)
	start_menu.StartGame.connect(load_game)
	#start_menu.Tutorial.connect()
	#start_menu.Credits.connect()
	start_menu.ExitGame.connect(exit_game)

func load_game() -> void:
	# unload start screen
	start_menu.queue_free()
	# load main game
	game = PROTOTYPE_SCENE.instantiate()
	get_tree().root.add_child(game)
	game.GameOver.connect(game_over_screen)

func game_over_screen() -> void:
	# unload game
	game.queue_free()
	# load game over screen
	game_over = GAME_OVER_SCREEN.instantiate()
	get_tree().root.add_child(game_over)
	game_over.ReturnToMenu.connect(load_main_menu)
	
func load_main_menu() -> void:
	# unload game over screen
	game_over.queue_free()
	# load start menu
	load_start_menu()
	
func exit_game() -> void:
	get_tree().quit()
	
