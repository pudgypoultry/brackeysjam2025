class_name SlotsLogic
extends Node2D

signal roll_finished(slot_id: int, result: int)

@export var speed: float = 900.0
@export var settle_time: float = 0.25
@export var sprite: Sprite2D
@export var stop_anchor: Node2D
@export var slot_id: int = 0
@export var first_column: int = 0
@export var row_labels: PackedStringArray = []  

var tween: Tween
var rolling: bool = false
var rows: int = 1
var cols: int = 1
var eff_cell: float = 0.0
var loop_span: float = 0.0
var anchor_global_y: float = 0.0
var last_result: int = -1

var strip_sprites: Array[Sprite2D] = []
var strip_length: int = 6

func _ready() -> void:
	if sprite == null:
		for c in get_children():
			if c is Sprite2D:
				sprite = c
				break
	if stop_anchor == null:
		stop_anchor = get_node_or_null("stopanchor")
	if sprite == null:
		push_error("slotslogic.gd: no Sprite2D child found")
		set_process(false)
		return

	sprite.centered = true
	sprite.offset = Vector2.ZERO
	sprite.region_enabled = false

	cols = max(1, sprite.hframes)
	rows = max(1, sprite.vframes)
	first_column = clamp(first_column, 0, cols - 1)

	var tex_h: float = sprite.texture.get_height() if sprite.texture else 0.0
	var base_cell_h: float = (tex_h / float(rows)) if rows > 0 else 0.0
	eff_cell = base_cell_h * max(0.0001, abs(sprite.scale.y))
	if eff_cell <= 0.0:
		eff_cell = 16.0

	loop_span = eff_cell * float(rows)

	anchor_global_y = stop_anchor.global_position.y if stop_anchor != null else sprite.global_position.y
	sprite.global_position.y = round(anchor_global_y)
	
	_create_strip()

func _create_strip() -> void:
	for strip_sprite in strip_sprites:
		if is_instance_valid(strip_sprite):
			strip_sprite.queue_free()
	strip_sprites.clear()
	
	strip_sprites.append(sprite)
	
	for i in range(1, strip_length):
		var new_sprite = Sprite2D.new()
		new_sprite.texture = sprite.texture
		new_sprite.hframes = sprite.hframes
		new_sprite.vframes = sprite.vframes
		new_sprite.frame = sprite.frame
		new_sprite.centered = sprite.centered
		new_sprite.offset = sprite.offset
		new_sprite.scale = sprite.scale
		new_sprite.region_enabled = sprite.region_enabled
		
		new_sprite.global_position = sprite.global_position
		if i <= 3:
			new_sprite.global_position.y -= eff_cell * i
		else:
			new_sprite.global_position.y += eff_cell * (i - 3)
		
		add_child(new_sprite)
		strip_sprites.append(new_sprite)

func _update_strip_positions(delta: float) -> void:
	for i in range(strip_sprites.size()):
		var strip_sprite = strip_sprites[i]
		var base: float = anchor_global_y
		var y: float = strip_sprite.global_position.y + speed * delta
		var wrapped: float = base + fposmod(y - base, loop_span)
		strip_sprite.global_position.y = wrapped
		
		var row_index: int = int(floor(fposmod(strip_sprite.global_position.y - base, loop_span) / eff_cell)) % rows
		_set_sprite_row(strip_sprite, row_index)

func _set_sprite_row(sprite_to_update: Sprite2D, row_index: int) -> void:
	if cols * rows <= 1:
		return
	row_index = clamp(row_index, 0, rows - 1)
	var frame_index: int = row_index * cols + first_column
	sprite_to_update.frame = frame_index

func get_row_count() -> int:
	return rows

func get_row_label(row: int) -> String:
	var n := get_row_count()
	if row_labels.size() >= n:
		return row_labels[clamp(row, 0, n - 1)]
	return str(row)

func _set_row(row_index: int) -> void:
	for strip_sprite in strip_sprites:
		_set_sprite_row(strip_sprite, row_index)

func start_roll() -> void:
	rolling = true
	if tween and tween.is_running():
		tween.kill()

func _process(delta: float) -> void:
	if not rolling:
		return
	
	_update_strip_positions(delta)

func stop_to_symbol(target_row: int, settle_time_override: float = -1.0) -> void:
	rolling = false
	if tween and tween.is_running():
		tween.kill()

	last_result = target_row % rows
	_set_row(last_result)

	var t: float = settle_time if settle_time_override < 0.0 else settle_time_override
	
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	for i in range(strip_sprites.size()):
		var strip_sprite = strip_sprites[i]
		var final_pos: Vector2 = strip_sprite.global_position
		if i == 0:
			final_pos.y = round(anchor_global_y)
		elif i <= 3:
			final_pos.y = round(anchor_global_y - (eff_cell * i))
		else:
			final_pos.y = round(anchor_global_y + (eff_cell * (i - 3)))
		tween.parallel().tween_property(strip_sprite, "global_position", final_pos, t)
	
	await tween.finished
	tween = null

	var visible_row: int = last_result
	roll_finished.emit(slot_id, visible_row)
	if Engine.has_singleton("SignalBank"):
		SignalBank.rollFinished.emit(slot_id, visible_row)
