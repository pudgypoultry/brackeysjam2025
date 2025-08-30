extends State

var parentCharacter : CharacterBody2D

@export_category("Game Rules")


@export_category("Plugging in Nodes")
@export var movingState : Node
@export var searchingState : Node

func Enter(oldState:State) -> void:
	super(oldState)


func Exit(newState:State) -> void:
	super(newState)
	


func Update(delta) -> void:
	super(delta)
	if stateManager.currentNoise > 1.0:
		stateManager.currentNoise -= delta * 0.25
	


func PhysicsUpdate(delta) -> void:
	super(delta)


func InterpretInput(axisUD : float, axisLR : float, interacting : bool):
	if interacting && stateManager.isNearInteractable:
		if !stateManager.currentInteractable.hasBeenInteractedWith:
			Exit(searchingState)
	if axisUD != 0 or axisLR != 0:
		Exit(movingState)
