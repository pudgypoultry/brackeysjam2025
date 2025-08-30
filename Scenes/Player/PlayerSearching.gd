extends State

@export_category("Game Rules")
@export var movementSpeed : float = 500.0
@export var slotScaleFactor : float = 0.25

@export_category("Plugging in Nodes")
@export var idleState : Node
@export var movingState : Node

var parentCharacter : CharacterBody2D
var movementDirection : Vector2
var doneInteracting : bool = false

# connect to spin_result(type:spin_outcome, item:String)

func Enter(old_state:State) -> void:
	super(old_state)
	doneInteracting = false
	stateManager.currentInteractable.hasBeenInteractedWith = true
	### BEGIN VOLATILE SECTION
	var slotMachine = stateManager.currentInteractable.slotMachineController.instantiate()
	parentCharacter.add_child(slotMachine)
	slotMachine.scale *= slotScaleFactor
	var signalToWaitFor = slotMachine.spin_result.connect(HandleSlotReward)
	print("Started Spinning")
	await Signal(slotMachine, "spin_result")
	print("Finished Spinning")
	#TODO: Need to retrieve reward from spin
	# slotMachine.queue_free()
	### END VOLATILE SECTION
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


func HandleSlotReward(type : slot_machine_ctrl.spin_outcome, item : String):
	print("SLOT MACHINE RESULT: " + item + str(type))
