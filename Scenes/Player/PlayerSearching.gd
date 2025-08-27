extends State

@export_category("Game Rules")
@export var movementSpeed : float = 500.0

@export_category("Plugging in Nodes")
@export var idleState : Node
@export var movingState : Node

var parentCharacter : StaticBody2D
var movementDirection : Vector2


func Enter(old_state:State) -> void:
	super(old_state)
	var slotMachine = stateManager.currentInteractable.slotMachineController.instantiate()
	get_tree().root.add_child(slotMachine)
	print("Started Spinning")
	await get_tree().create_timer(stateManager.currentInteractable.spinTime).timeout
	print("Finished Spinning")


func Exit(new_state:State) -> void:
	super(new_state)
	


func Update(delta) -> void:
	super(delta)
	


func PhysicsUpdate(delta) -> void:
	super(delta)
	parentCharacter.position += movementDirection * movementSpeed * delta


# Called from parent StateManager
func InterpretInput(axisUD : float, axisLR : float, interacting : bool):
	if axisUD == 0 and axisLR == 0 && interacting:
		Exit(idleState)
	elif interacting:
		Exit(movingState)
