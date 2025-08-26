extends State

@export_category("Game Rules")
@export var movementSpeed : float = 500.0

@export_category("Plugging in Nodes")
@export var idleState : Node
@export var searchingState : Node

var parentCharacter : StaticBody2D
var movementDirection : Vector2


func Enter(old_state:State) -> void:
	super(old_state)
	stateManager.canRotate = true


func Exit(new_state:State) -> void:
	super(new_state)
	


func Update(delta) -> void:
	super(delta)
	


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
	if axisUD == 0 and axisLR == 0:
		Exit(idleState)
