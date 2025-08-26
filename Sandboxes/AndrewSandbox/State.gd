# Adapted from https://github.com/pudgypoultry/godotwildjam7-25/blob/main/Sandboxes/Stella/State.gd
extends Node
# skeleton of this code comes from this tutorial:
# https://www.youtube.com/watch?v=ow_Lum-Agbs&ab_channel=Bitlytic
class_name State

var stateManager : StateManager

signal Transitioned(oldState:State, newState:State)

func Enter(oldState:State) -> void:
	# called when the state is entered
	pass
	


func Exit(newState:State) -> void:
	# called when the state is exited
	Transitioned.emit(self, newState)
	newState.Enter(self)
	


func Update(delta) -> void:
	pass
	


func PhysicsUpdate(delta) -> void:
	pass
	
