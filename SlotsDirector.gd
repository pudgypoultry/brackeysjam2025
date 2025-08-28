# SlotsDirector.gd (Godot 4.x)
extends Node

## Assign your three Slotslogic nodes in the editor.
@export var reels: Array[NodePath] = []

## Timing (seconds)
@export var spin_time: float = 1.8
@export var stop_gap: float = 0.35
@export var settle_time_override: float = -1.0  # passed to reel.stop_to_symbol(); -1 uses reel default

## Win bias (ensure p_three_of_a_kind + p_two_of_a_kind <= 1.0)
@export_range(0.0, 1.0, 0.01) var p_three_of_a_kind: float = 0.8
@export_range(0.0, 1.0, 0.01) var p_two_of_a_kind: float = 0.20

## Optional symbol weighting; length MUST equal reel.rows (8). Leave empty for uniform.
@export var symbol_weights: PackedFloat32Array = []

var _rng := RandomNumberGenerator.new()
var _reel_refs: Array = []

signal spin_started()
signal spin_finished(result_rows: Array[int])

func _ready() -> void:
	_rng.randomize()
	_reel_refs.clear()
	for p in reels:
		var n := get_node_or_null(p)
		if n == null:
			push_error("SlotsDirector: missing reel at %s" % [str(p)])
		else:
			_reel_refs.append(n)

func _weighted_pick(weights: PackedFloat32Array) -> int:
	var total := 0.0
	for w in weights:
		total += max(w, 0.0)
	if total <= 0.0:
		return _rng.randi_range(0, weights.size() - 1)
	var r := _rng.randf() * total
	var acc := 0.0
	for i in range(weights.size()):
		acc += max(weights[i], 0.0)
		if r <= acc:
			return i
	return weights.size() - 1

func _pick_row_uniform(rows: int) -> int:
	return _rng.randi_range(0, rows - 1)

func _pick_row_with_weights(rows: int) -> int:
	if symbol_weights.size() == rows:
		return _weighted_pick(symbol_weights)
	return _pick_row_uniform(rows)

func _pick_row_with_weights_excluding(rows: int, exclude: int) -> int:
	# Weighted pick, excluding one index
	if symbol_weights.size() == rows:
		var w := PackedFloat32Array(symbol_weights)
		if exclude >= 0 and exclude < rows:
			w[exclude] = 0.0
		var sum := 0.0
		for v in w:
			sum += v
		if sum > 0.0:
			return _weighted_pick(w)
	# Uniform pick excluding `exclude`
	var r := _rng.randi_range(0, rows - 2)
	return (r + 1) if (r >= exclude) else r

func _choose_outcome(rows: int) -> Array[int]:
	# Returns [r1, r2, r3] with biases applied
	var roll := _rng.randf()
	if roll < p_three_of_a_kind:
		var k := _pick_row_with_weights(rows)
		return [k, k, k]
	elif roll < p_three_of_a_kind + p_two_of_a_kind:
		# two of a kind: choose which pair, base row, and odd-one-out
		var pair := _rng.randi_range(0, 2)  # 0:(0,1) 1:(0,2) 2:(1,2)
		var base := _pick_row_with_weights(rows)
		var odd := _pick_row_with_weights_excluding(rows, base)
		if pair == 0:
			return [base, base, odd]
		elif pair == 1:
			return [base, odd, base]
		else:
			return [odd, base, base]
	else:
		# all different; try to avoid dupes even with skewed weights
		var a := _pick_row_with_weights(rows)
		var b := _pick_row_with_weights_excluding(rows, a)
		var c := _pick_row_with_weights_excluding(rows, a)
		var tries := 4
		while (c == b or c == a) and tries > 0:
			c = _pick_row_with_weights_excluding(rows, a)
			tries -= 1
		if c == a or c == b:
			for i in range(rows):
				if i != a and i != b:
					c = i
					break
		return [a, b, c]

func start_spin() -> void:
	if _reel_refs.size() == 0:
		push_error("SlotsDirector: no reels assigned.")
		return

	emit_signal("spin_started")

	# Start all reels
	for r in _reel_refs:
		r.start_roll()

	# Decide results up front
	var rows :int = _reel_refs[0].get_row_count()
	var results := _choose_outcome(rows)

	# Schedule stops with gaps
	_stop_reel_after_delay(_reel_refs[0], results[0], spin_time)
	if _reel_refs.size() > 1:
		_stop_reel_after_delay(_reel_refs[1], results[1], spin_time + stop_gap)
	if _reel_refs.size() > 2:
		_stop_reel_after_delay(_reel_refs[2], results[2], spin_time + 2.0 * stop_gap)

	# Emit finished after last stop (rough estimate)
	var settle := settle_time_override if settle_time_override > 0.0 else 0.0
	_wait_and_emit_results(results, spin_time + 2.0 * stop_gap + settle)

func _stop_reel_after_delay(reel: Node, row: int, delay_s: float) -> void:
	await get_tree().create_timer(max(0.0, delay_s)).timeout
	if is_instance_valid(reel):
		reel.stop_to_symbol(row, settle_time_override)

func _wait_and_emit_results(results: Array[int], delay_s: float) -> void:
	await get_tree().create_timer(max(0.0, delay_s)).timeout
	emit_signal("spin_finished", results)
