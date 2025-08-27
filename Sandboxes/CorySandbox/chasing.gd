extends State

@export var searching_state:State
# moves to last known position of the player
# transition back to Searching with a detection meter set to 90% if player
# is not visible once the last known position is reached
# if the player is in the vision cone, update the last known position

var player_last_known_pos:Vector2

func Enter(old_state:State) -> void:
	super(old_state)
	# update last known position, when state is entered we know detection is at 100%
	player_last_known_pos = stateManager.player.position
	
func Exit(new_state:State) -> void:
	super(new_state)
	
func Update(_delta) -> void:
	super(_delta)

func PhysicsUpdate(_delta) -> void:
	super(_delta)
	# update last known position if player is spotted
	if stateManager.is_player_visiable():
		player_last_known_pos = stateManager.player.position
	# TODO move to player_last_known_pos
