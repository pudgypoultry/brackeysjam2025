extends Node
@onready var reel1: Node2D =$Slot1
@onready var reel2: Node2D =$Slot2
@onready var reel3: Node2D =$Slot3
var reels: Array[Node2D]

@export var spin_time: float = 1.5
@export var stop_gap: float = 0.3
@export var symbol_count : int = 9 

var spinning := false



func _ready()-> void:
	reels = [reel1, reel2, reel3]

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		if spinning:
			return
		start_spin()
func start_spin() -> void:
	spinning = true
	for r in reels:
		r.call("start_roll")
		finish_spin()
		
func finish_spin()-> void:
	var when:= 0.0
	for r in reels:
		var target := randi_range(0, max(0, symbol_count - 1))
		_stop_one(r,target,when)
		when += stop_gap
func _stop_one(r: Node2D, target_index: int, delay: float) -> void:
	await get_tree().create_timer(spin_time + delay).timeout
	r.call("stop_to_symbol", target_index, 0.35)
	if r == reels.back():
		await get_tree().create_timer(0.4).timeout
		spinning= false
