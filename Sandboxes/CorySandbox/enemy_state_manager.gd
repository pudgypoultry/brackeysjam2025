extends StateManager

@export var vision_cone:Area2D
@export var nav_agent:NavigationAgent2D
@onready var enemy: Node2D = $".."
@onready var player: Node2D = enemy.player
@export var wait_state:State
var player_in_cone:bool = false
# layer 2 == things that block vision, layer 16 player only
const vision_mask:int = pow(2, 2-1) + pow(2, 16-1)

func move_agent(delta:float, is_running:bool=false) -> void:
	#if not nav_agent.is_navigation_finished():
	var dest:Vector2 = nav_agent.get_next_path_position()
	var dir:Vector2 = dest - enemy.position
	var n:float = 1
	if is_running:
		n = enemy.run_speed_factor
	enemy.position += dir.normalized() * enemy.movement_speed * delta * n
	enemy.look_at(dest)

func is_player_spotted() -> bool:
	return enemy.detection >= enemy.max_detection - enemy.detection_threshold
	
func is_player_hidden() -> bool:
	return enemy.detection <= enemy.min_detection + enemy.detection_threshold

func is_player_visiable() -> bool:
	# check if player is colliding with area
	if player_in_cone:
		# area 2d uses a mask that only the player is on
		# check if a ray is unobstructed
		# check a physics process raycast to see if the player can be seen
		var space_state = enemy.get_world_2d().direct_space_state
		# construct a ray from enemy position to player position, use the vision mask
		var query = PhysicsRayQueryParameters2D.create(enemy.position, player.position, vision_mask)
		# run the ray cast
		var result = space_state.intersect_ray(query)
		# check the result
		if result and result.collider == player:
			enemy.player_detected = true
			return true
	enemy.player_detected = false
	return false


func _on_vision_cone_body_entered(body: Node2D) -> void:
	if body == player:
		player_in_cone = true


func _on_vision_cone_body_exited(body: Node2D) -> void:
	if body == player:
		player_in_cone = false
		
func on_state_transition(oldState:State, newState:State):
	super(oldState, newState)
	enemy.state_label.text = str(newState.name)[0]
