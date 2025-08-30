extends Node2D
class_name slot_machine_ctrl

const SLOT_COLUMN = preload("res://Scenes/SlotMachine/slot_column.tscn")
@onready var dumpster_sprite: Node2D = $DumpsterSprite
@onready var label: Label = $Label
@onready var slot_mask: Sprite2D = $Slot_mask
@onready var slot_columns: Array[SlotColumn] = [$Slot_mask/SlotColumn, $Slot_mask/SlotColumn2, $Slot_mask/SlotColumn3]

var slot1_values:Array[int] = [0, 8, 16, 24, 32, 40, 48, 56]
var slot1_names:Array[String] = ["cookie", "wine", "egg", "cheese", "tomato", "pretzel", "watermelon", "avocado"]

var col_values:Array = [slot1_values, slot1_values, slot1_values]
var col_names:Array  = [slot1_names,  slot1_names,  slot1_names]

@export var base_spin_time: float = 1.2
@export var stop_gap: float = 0.25
@export var extra_loops: int = 2
@export var easing: Tween.EaseType = Tween.EASE_OUT
@export var trans: Tween.TransitionType = Tween.TRANS_QUAD

signal done_spinning()
signal spin_result(type:spin_outcome, item:String)
enum spin_outcome {Three_Match=0, Two_Match=1, No_Match=2}

var column_size:int = 0
var column_span: float = 0.0
var spin_lock: bool = false

func _ready() -> void:
	column_size = slot1_values.size()
	column_span = slot_columns[0].slot_v_offset * float(column_size) * slot_columns[0].scale.y
	for i in range(slot_columns.size()):
		slot_columns[i].build_column(col_values[i])
		slot_columns[i].position.y = -0.0

func spin() -> Array[int]:
	if spin_lock:
		return []
	spin_lock = true
	dumpster_sprite.play_anim()
	var longest_tween: Tween = null

	for i in range(slot_columns.size()):
		var col := slot_columns[i]
		var idx:int = randi() % col.slot_array.size()
		var frac := float(idx) / float(col.slot_array.size())
		var travel: float = (float(extra_loops) * column_span) + (frac * column_span)
		var target_y := col.position.y - travel
		var duration := base_spin_time + (float(i) * stop_gap)
		var t := create_tween().set_trans(trans).set_ease(easing)
		t.tween_property(col, "position:y", target_y, duration)
		if longest_tween == null or duration > longest_tween.get_total_elapsed_time():
			longest_tween = t

	if longest_tween != null:
		await longest_tween.finished

	for i in range(slot_columns.size()):
		var col := slot_columns[i]
		var y := col.position.y
		var wrapped :float = y - floor(y / -column_span) * -column_span
		col.position.y = wrapped

	var result_idx:Array[int] = []
	var result_names:Array[String] = []
	var result_frames:Array[int] = []
	for i in range(slot_columns.size()):
		var col := slot_columns[i]
		var step := col.slot_v_offset * col.scale.y
		var offset := fposmod(-col.position.y, column_span)
		var visible := int(round(offset / step)) % column_size
		result_idx.append(visible)
		result_names.append(col_names[i][visible])
		result_frames.append(col_values[i][visible])

	print("spin results (idx): ", result_idx, " | names: ", result_names, " | frames: ", result_frames)
	check_win(result_names)

	spin_lock = false
	return result_idx

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Spin Slot Machine"):
		spin()
	if event.is_action_pressed("ExitSlotMachine") and !spin_lock:
		EndSlotMachine()

func check_win(result_names: Array[String]) -> void:
	if result_names.size() < 3:
		return
	var counts := {}
	for n in result_names:
		counts[n] = (counts.get(n, 0) as int) + 1
	var max_count := 0
	var winner := ""
	for k in counts.keys():
		var c:int = counts[k]
		if c > max_count:
			max_count = c
			winner = k
	if max_count == 3:
		print("🦝 WHOA! Jackpot! 3 ", winner, "s! You're really 'racc-rolling' now! 🦝")
		label.text = "WHOA! Jackpot! 3 %ss! You're really 'racc-rolling' now!" % winner
		spin_result.emit(spin_outcome.Three_Match, winner)
	elif max_count == 2:
		print(" Two ", winner, "s! A 'racc-tacular' little win! ")
		label.text = " Two %ss! A 'racc-tacular' little win! " % winner
		spin_result.emit(spin_outcome.Two_Match, winner)
	else:
		print("No win! keep 'racc-ing' those spins!")
		label.text = "No win! keep 'racc-ing' those spins!"
		spin_result.emit(spin_outcome.No_Match, winner)

func EndSlotMachine():
	emit_signal("done_spinning")
