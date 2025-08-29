extends Interactable

@export_category("Game Rules")
@export var slotMachineController : PackedScene
@export var rewards : Array

@export_category("Plugging in Nodes")
@export var sprite : Sprite2D

var spinTime : float = 10.0
var hasBeenInteractedWith : bool = false

func _ready():
	pass
	
