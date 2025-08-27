extends StateManager

@export var interactableChecker : Area2D

var forwardBackward : float = 0.0
var leftRight : float = 0.0
var tryingToInteract : bool = false
var parentCharacter : StaticBody2D
var isNearInteractable : bool = false
var currentInteractable : Node = null


func _ready():
	super._ready()
	parentCharacter = get_parent()
	for state in get_children():
		state.parentCharacter = parentCharacter


func _process(delta):
	HandleInput(delta)
	ApplyInput(forwardBackward, leftRight, tryingToInteract)
	currentState.Update(delta)
	


func _physics_process(delta: float) -> void:
	currentState.PhysicsUpdate(delta)
	# parentCharacter.move_and_slide()

func HandleInput(delta):
	forwardBackward = Input.get_axis("MoveDown", "MoveUp")
	leftRight = Input.get_axis("MoveLeft", "MoveRight")
	tryingToInteract = Input.is_action_just_pressed("Interact")
	


func ApplyInput(axisUD : float, axisLR : float, interacting : bool):
	currentState.InterpretInput(axisUD, axisLR, interacting)
	


func InteractableReady(interactable : Node2D):
	if interactable is Interactable:
		isNearInteractable = true
		currentInteractable = interactable
		print(currentInteractable.enterString)


func InteractableUnready(interactable : Node2D):
	if interactable is Interactable:
		print(currentInteractable.leaveString)
		isNearInteractable = false
		currentInteractable = null
