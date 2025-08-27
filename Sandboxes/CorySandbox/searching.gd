extends State

@export var idle_state:State
@export var chasing_state:State
# adds to detection meter while player is in the vision cone
# if player is not in the vision cone, the detection meter slowly decays
# transition to Idle if detection meter is empty
# transition to Chasing if detection meter is full

func Enter(old_state:State) -> void:
	super(old_state)
	
func Exit(new_state:State) -> void:
	super(new_state)
	
func Update(_delta) -> void:
	super(_delta)

func PhysicsUpdate(_delta) -> void:
	super(_delta)
	if stateManager.is_player_visiable():
		if stateManager.is_player_spotted():
			# move to chasing_state
			chasing_state.Enter(self)
		elif stateManager.is_player_hidden():
			# move to idle_state
			idle_state.Enter(self)
