extends Node2D
class_name SlotMachineController

@onready var reel1: SlotsLogic = $Slot1
@onready var reel2: SlotsLogic = $Slot2
@onready var reel3: SlotsLogic = $Slot3
var reels: Array[SlotsLogic]

@export var spin_time: float = 1.5
@export var stop_gap: float = 0.3

var _spinning: bool = false
var _finished_count: int = 0
var _results: Array[int] = []

func _ready() -> void:
	randomize()
	reels = [reel1, reel2, reel3]
	for i in reels.size():
		reels[i].slot_id = i
		reels[i].roll_finished.connect(_on_reel_finished)
	_results.resize(reels.size())
	if Engine.has_singleton("SignalBank"):
		SignalBank.rollFinished.connect(_on_reel_finished)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and not _spinning:
		start_spin()

func start_spin() -> void:
	_spinning = true
	var delay: float = 0.0
	for i in reels.size():
		var duration: float = spin_time + delay
		if Engine.has_singleton("SignalBank"):
			SignalBank.startRoll.emit(i, duration)
		reels[i].start_roll()
		delay += stop_gap
	_finish_spin()

func _finish_spin() -> void:
	var delay: float = 0.0
	for i in reels.size():
		var r: SlotsLogic = reels[i]
		var rows: int = max(1, r.get_row_count())
		var target_row: int = randi_range(0, rows - 1)
		_stop_one(r, target_row, delay)
		delay += stop_gap

func _stop_one(r: SlotsLogic, target_row: int, delay: float) -> void:
	await get_tree().create_timer(spin_time + delay).timeout
	var settle: float = 0.25 + delay * 0.2
	r.stop_to_symbol(target_row, settle)

func _on_reel_finished(slot_id: int, result: int) -> void:
	_results[slot_id] = result
	var name := reels[slot_id].get_row_label(result)
	print("Slot ", slot_id + 1, ": index=", result, " -> ", name)
	_finished_count += 1
	if _finished_count == reels.size():
		_finished_count = 0
		_spinning = false
		print("Spin result (idx): ", _results)
		var names := []
		for i in reels.size():
			names.append(reels[i].get_row_label(_results[i]))
		print("Spin result (names): ", names)
