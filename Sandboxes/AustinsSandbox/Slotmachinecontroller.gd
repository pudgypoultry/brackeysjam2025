extends Node2D

@onready var reel1: Node2D = $Slot1
@onready var reel2: Node2D = $Slot2
@onready var reel3: Node2D = $Slot3
var reels: Array[Node2D]

@export var spin_time: float = 1.5     # how long reels spin before first stop
@export var stop_gap: float = 0.3      # delay between stopping each reel
@export var symbol_count: int = 9      # hframes * vframes of your atlas

var spinning := false

func _ready() -> void:
	reels = [reel1, reel2, reel3]
	# uncomment to auto-demo:
	# start_spin()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and not spinning:
		start_spin()

func start_spin() -> void:
	spinning = true
	for r in reels:
		r.call("start_roll")
	_finish_spin()

func _finish_spin() -> void:
	var delay = 0.0
	for r in reels:
		var target = randi_range(0, max(0, symbol_count - 1))
		_stop_one(r, target, delay)
		delay += stop_gap

func _stop_one(r: Node2D, target_index: int, delay: float) -> void:
	await get_tree().create_timer(spin_time + delay).timeout
	r.call("stop_to_symbol", target_index, 0.35)
	if r == reels.back():
		await get_tree().create_timer(0.4).timeout
		spinning = false
