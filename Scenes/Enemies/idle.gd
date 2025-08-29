extends State

@export var searching_state:State
@export var waiting_state:State
var path:Array
var index:int = 0
# follows default patrol path or stands still
# transitions to Searching if player enters vision cone

func Enter(old_state:State) -> void:
	super(old_state)
	path = stateManager.parent_node.patrol_path.get_children()
	index = (index + 1) % path.size()
	
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
		if stateManager.nav_agent.target_position != get_path_position():
			print("moving to postion ", get_path_position())
			# update position
			stateManager.nav_agent.target_position = get_path_position()
	stateManager.move_agent(_delta)
	# exit to waiting state when navigation is finished
	if stateManager.nav_agent.is_navigation_finished():
		self.Exit(waiting_state)
		return

func get_path_position() -> Vector2:
	return path[index].position + stateManager.parent_node.patrol_path.position
