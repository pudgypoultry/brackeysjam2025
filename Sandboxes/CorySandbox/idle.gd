extends State

@export var searching_state:State
# follows default patrol path or stands still
# transitions to Searching if player enters vision cone

func Enter(old_state:State) -> void:
	super(old_state)
	
func Exit(new_state:State) -> void:
	super(new_state)
	
func Update(_delta) -> void:
	super(_delta)

func PhysicsUpdate(_delta) -> void:
	super(_delta)
	# check for transitioning to searching state
	if stateManager.is_player_visiable():
		searching_state.Enter(self)
