extends Node2D
class_name SlotColumn

@export var slot_v_offset:float = 20

const SLOT = preload("res://Scenes/SlotMachine/slot.tscn")
var slot_array:Array[Node2D] = []

var tmp:float = 0
var doOnce:bool = false

func build_column(slots:Array[int]) -> void:
	for i in slots.size():
		var obj = SLOT.instantiate()
		self.add_child(obj)
		obj.set_slot(slots[i])
		obj.position += Vector2(0, i * slot_v_offset) 
		slot_array.append(obj)
