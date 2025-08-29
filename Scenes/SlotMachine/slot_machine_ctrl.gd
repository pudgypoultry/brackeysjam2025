extends Node2D

const SLOT_COLUMN = preload("res://Scenes/SlotMachine/slot_column.tscn")

@onready var slot_mask: Sprite2D = $Slot_mask
@onready var slot_columns: Array[SlotColumn] = [$Slot_mask/SlotColumn, $Slot_mask/SlotColumn2, $Slot_mask/SlotColumn3]

var slot1_values:Array[int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 11]
#var slot2_values:Array[int] = [10, 15, 20]
#var slot3_values:Array[int] = [7, 5, 3]
var column_size:int = slot1_values.size()
var column_offset:float
var current_column_offsets:Array[float] = [0, 0, 0]
var spin_count:int = 0
var current_spin:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# vertical offset of the full slot column
	column_offset = -slot_columns[0].slot_v_offset * column_size * slot_columns[0].scale.y
	
	slot_columns[0].build_column(slot1_values)
	slot_columns[0].position += Vector2(0, column_offset)
	
	slot_columns[1].build_column(slot1_values)
	slot_columns[1].position += Vector2(0, column_offset)
	
	slot_columns[2].build_column(slot1_values)
	slot_columns[2].position += Vector2(0, column_offset)


# spins the slot_machine and returns the indexes of the resulting slots
func spin() -> Array[int]:
	var result_array:Array[int] = []
	for i in slot_columns.size():
		# pick a random index
		var result:int = randi() % slot_columns[i].slot_array.size()
		result_array.append(result)
		# TODO reset column offsets if repeating
		if current_column_offsets[i] != 0:
			slot_columns[i].position -= Vector2(0, current_column_offsets[i])
			current_column_offsets[i] -= current_column_offsets[i]
		# TODO tween column down offset/(result/col.slot_array.size())
		var result_offset:float = column_offset - (column_offset * (float(result) / float(slot_columns[i].slot_array.size())) )
		current_column_offsets[i] -= result_offset
		slot_columns[i].position -= Vector2(0, result_offset)
		# TODO increment spin count once tween is finished
	print("spin results: ", result_array)
	await get_tree().create_timer(0.2).timeout
	spin_count += 1
	return result_array
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("Spin Slot Machine") and current_spin == spin_count:
		current_spin += 1
		spin()
