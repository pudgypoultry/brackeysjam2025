extends State

@export var searching_state:State
@export var waiting_state:State
var path:Node2D
# follows default patrol path or stands still
# transitions to Searching if player enters vision cone

func Enter(old_state:State) -> void:
	super(old_state)
	path = stateManager.enemy.patrol_path
	
func Exit(new_state:State) -> void:
	super(new_state)
	
func Update(_delta) -> void:
	super(_delta)

func PhysicsUpdate(_delta) -> void:
	super(_delta)
	# check for transitioning to searching state
	if stateManager.is_player_visiable():
		self.Exit(searching_state)
		return
	if path:
		# follow patrol path while in this state
		if stateManager.nav_agent.target_position != path.position:
			print("moving to postion ", path.position)
			# update position
			stateManager.nav_agent.target_position = path.position
	stateManager.move_agent(_delta)
	# exit to waiting state when navigation is finished
	if stateManager.nav_agent.is_navigation_finished():
		self.Exit(waiting_state)
		return
