extends State

# moves to last known postion of the player
# transtion back to Searching with a detection meter set to 90% if player
# is not visible once the last known postion is reached
# if the player is in the vision cone, update the last known postion

var player_last_known_pos:Vector2

func Enter(old_state:State) -> void:
	super(old_state)
	
func Exit(new_state:State) -> void:
	super(new_state)
	
func Update(_delta) -> void:
	super(_delta)

func PhysicsUpdate(_delta) -> void:
	super(_delta)
