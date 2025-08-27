extends State

var return_state:State
@export var searching_state:State
@export var wait_delay:float = 5.0
var current_delay:float

func Enter(old_state:State) -> void:
	super(old_state)
	return_state = old_state
	current_delay = wait_delay
	
func Exit(new_state:State) -> void:
	super(new_state)
	
func Update(_delta) -> void:
	super(_delta)

func PhysicsUpdate(_delta) -> void:
	super(_delta)
	current_delay -= _delta
	# exit state if player is visiable
	if stateManager.is_player_visiable():
		self.Exit(searching_state)
		return
	# leave state if wait is over
	if current_delay <= 0:
		self.Exit(return_state)
		return
