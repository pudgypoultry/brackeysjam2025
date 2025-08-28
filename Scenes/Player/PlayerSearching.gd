extends State

@export_category("Game Rules")
@export var movementSpeed : float = 500.0

@export_category("Plugging in Nodes")
@export var idleState : Node
@export var movingState : Node

var parentCharacter : CharacterBody2D
var movementDirection : Vector2
var doneInteracting : bool = false


func Enter(old_state:State) -> void:
	super(old_state)
	doneInteracting = false
	stateManager.currentInteractable.hasBeenInteractedWith = true
	var slotMachine = stateManager.currentInteractable.slotMachineController.instantiate()
	get_tree().root.add_child(slotMachine)
	print("Started Spinning")
	await get_tree().create_timer(stateManager.currentInteractable.spinTime).timeout
	print("Finished Spinning")
	slotMachine.queue_free()
	doneInteracting = true


func Exit(new_state:State) -> void:
	super(new_state)
	


func Update(delta) -> void:
	super(delta)
	


func PhysicsUpdate(delta) -> void:
	super(delta)
	parentCharacter.position += movementDirection * movementSpeed * delta


# Called from parent StateManager
func InterpretInput(axisUD : float, axisLR : float, interacting : bool):
	if doneInteracting:
		Exit(idleState)
