extends Node2D

@onready var label: Label = $Label

@export var player:Node2D
@export var state_manager: StateManager
@export var ChasingState: State
@export var patrol_path:Node2D
@export var detection_grow_rate:float = 50
@export var detection_decay_rate:float = 20
@export var max_detection:float = 100
@export var min_detection:float = 0
@export var detection_threshold:float = 5
@export var movement_speed:float = 50
@export var run_speed_factor:float = 2
var detection:float = 0
var player_detected:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	# grow/decay detection score every physics frame
	if player_detected:
		detection = detection + detection_grow_rate * delta
	else:
		detection = detection - detection_decay_rate * delta
	# cap ends
	if detection < min_detection:
		detection = min_detection
	elif detection > max_detection:
		detection = max_detection
	label.text = str(detection)
		

# NOTE use this function to trigger a chase if the player makes too much noise
func AttackPlayer() -> void:
	# start chasing player
	ChasingState.Enter(state_manager.currentState)
	# full player detection
	detection = max_detection
