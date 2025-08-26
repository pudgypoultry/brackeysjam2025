extends StateManager

var forwardBackward : float = 0.0
var leftRight : float = 0.0
var cameraRotationAmountX : float = 0.0
var mouseSensitivityMultiplier = 0.005
var tryingToInteract : bool = false
var parentCharacter : StaticBody2D
var canRotate : bool = true


func _ready():
	super._ready()
	parentCharacter = get_parent()
	for state in get_children():
		state.parentCharacter = parentCharacter


func _process(delta):
	HandleInput(delta)
	ApplyInput(forwardBackward, leftRight)
	currentState.Update(delta)


func _physics_process(delta: float) -> void:
	currentState.PhysicsUpdate(delta)
	# parentCharacter.move_and_slide()

func HandleInput(delta):
	forwardBackward = Input.get_axis("MoveDown", "MoveUp")
	leftRight = Input.get_axis("MoveLeft", "MoveRight")
	tryingToInteract = Input.is_action_just_pressed("Interact")
	


func ApplyInput(axisUD : float, axisLR : float, interacting : bool):
	currentState.InterpretInput(axisUD, axisLR)
	
