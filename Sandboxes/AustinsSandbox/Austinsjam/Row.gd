extends Node
@onready var reel1: Node2D =$Slot1
@onready var reel2: Node2D =$Slot2
@onready var reel3: Node2D =$Slot3
var TWN: Tween


func _ready()-> void:
	assert(reel1 != null and reel2!=null and reel3 != null,"Slot1/2/3 not found from SlotRows")
	reel1.position.y = -16
	reel2.position.y=0
	reel3.position.y=16
