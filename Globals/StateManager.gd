extends Node

class_name StateManager

@export var initialState : Node
var currentState : Node
#var states : Dictionary = {}

func _ready():
	# add all states to the states dictionary, states are child nodes of the State Manager node
	for child in get_children():
		if child is State:
			# set up the states dictionary
			#states[child.name.to_lower()] = child
			child.Transitioned.connect(on_state_transition)
			child.stateManager = self

	if initialState:
		initialState.Enter(initialState)
		currentState = initialState
		print(initialState.name)


func _process(delta):
	if currentState:
		currentState.Update(delta)


func _physics_process(delta):
	if currentState:
		currentState.Physics_Update(delta)


func on_state_transition(oldState:State, newState:State):
	print("Transitioning from %s to %s" % [ oldState.name, newState.name ])
	currentState = newState
