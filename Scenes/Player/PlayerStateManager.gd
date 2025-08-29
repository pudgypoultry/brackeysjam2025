extends StateManager

@export var interactableChecker : Area2D
@export var noiseChecker : Area2D
@export var startingHunger : float = 0.0
@export var startingNoise : float = 1.0
@onready var animation_tree: AnimationTree = $"../AnimationTree"

var forwardBackward : float = 0.0
var leftRight : float = 0.0
var tryingToInteract : bool = false
var parentCharacter : CharacterBody2D
var isNearInteractable : bool = false
var currentInteractable : Node = null
var currentHunger : float
var currentNoise : float

func _ready():
	super._ready()
	currentHunger = startingHunger
	currentNoise = startingNoise
	parentCharacter = get_parent()
	for state in get_children():
		state.parentCharacter = parentCharacter


func _process(delta):
	HandleInput(delta)
	ApplyInput(forwardBackward, leftRight, tryingToInteract)
	currentState.Update(delta)
	noiseChecker.scale = currentNoise * Vector2.ONE


func _physics_process(delta: float) -> void:
	currentState.PhysicsUpdate(delta)
	# parentCharacter.move_and_slide()


func HandleInput(delta):
	forwardBackward = Input.get_axis("MoveDown", "MoveUp")
	leftRight = Input.get_axis("MoveLeft", "MoveRight")
	if forwardBackward == 0 and leftRight == 0:
		# pause animation when movment stops
		animation_tree["active"] = false
	else:
		# start animation and set blend space to movement
		animation_tree["active"] = true
		animation_tree["parameters/blend_position"].x = leftRight
		animation_tree["parameters/blend_position"].y = forwardBackward
	tryingToInteract = Input.is_action_just_pressed("Interact")
	


func ApplyInput(axisUD : float, axisLR : float, interacting : bool):
	currentState.InterpretInput(axisUD, axisLR, interacting)
	


func InteractableReady(interactable : Node2D):
	if interactable is Interactable:
		isNearInteractable = true
		currentInteractable = interactable
		# print(currentInteractable.enterString)


func InteractableUnready(interactable : Node2D):
	if interactable is Interactable:
		# print(currentInteractable.leaveString)
		isNearInteractable = false
		currentInteractable = null
