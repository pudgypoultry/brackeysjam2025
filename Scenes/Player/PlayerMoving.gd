extends State

@export_category("Game Rules")
@export var movementSpeed : float = 500.0

@export_category("Plugging in Nodes")
@export var idleState : Node
@export var searchingState : Node

var parentCharacter : CharacterBody2D
var movementDirection : Vector2


func Enter(old_state:State) -> void:
	super(old_state)
	


func Exit(new_state:State) -> void:
	super(new_state)
	


func Update(delta) -> void:
	super(delta)
	if stateManager.currentNoise > 1.0:
		stateManager.currentNoise -= delta * 0.5
	


func PhysicsUpdate(delta) -> void:
	super(delta)
	parentCharacter.position += movementDirection * movementSpeed * delta
	


# Called from parent StateManager
func InterpretInput(axisUD : float, axisLR : float, interacting : bool):
	#print("Poop")
	movementDirection = Vector2.ZERO
	movementDirection += axisUD * Vector2.UP
	movementDirection += axisLR * Vector2.RIGHT
	movementDirection = movementDirection.normalized()
	if interacting && stateManager.isNearInteractable:
		if !stateManager.currentInteractable.hasBeenInteractedWith:
			Exit(searchingState)
	if axisUD == 0 and axisLR == 0:
		Exit(idleState)
