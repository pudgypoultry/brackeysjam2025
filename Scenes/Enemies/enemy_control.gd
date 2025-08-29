extends Node2D

@onready var enemy_logic: Node2D = $EnemyLogic
@onready var detection_label: Label = enemy_logic.detection_label
@onready var state_label: Label = enemy_logic.state_label
@onready var state_manager: StateManager = enemy_logic.state_manager
@onready var ChasingState: State = enemy_logic.chasing
@onready var stealth_arrow: Node2D = enemy_logic.stealth_arrow

@export var player:Node2D
@export var patrol_path:Node2D

@export var detection_grow_rate:float = 50
@export var detection_decay_rate:float = 20
@export var max_detection:float = 100
@export var min_detection:float = 0
@export var detection_threshold:float = 5
@export var movement_speed:float = 60
@export var run_speed_factor:float = 3
var std_detection_sqr_mag:float = Vector2(300, 300).length_squared()
var detection:float = 0
var player_detected:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var x:float = std_detection_sqr_mag / ((player.position - self.position).length_squared() + 0.01)
	# grow/decay detection score every physics frame
	if player_detected:
		detection = detection + detection_grow_rate * delta * x
	else:
		detection = detection - detection_decay_rate * delta
	# cap ends
	if detection < min_detection:
		detection = min_detection
	elif detection > max_detection:
		detection = max_detection
	detection_label.text = "%.2f" % detection
	stealth_arrow.update_stealth_arrow(player.position, detection)
		

# NOTE use this function to trigger a chase if the player makes too much noise
func AttackPlayer() -> void:
	# start chasing player
	ChasingState.Enter(state_manager.currentState)
	# full player detection
	detection = max_detection
