extends StateManager

@export var vision_cone:Area2D
@export var nav_agent:NavigationAgent2D
@export var wait_state:State

@onready var enemy_logic: Node2D = $".."
@onready var animation_tree: AnimationTree = enemy_logic.animation_tree
@onready var parent_node:Node2D = enemy_logic.parent_node
@onready var player: Node2D = parent_node.player

var anim_threshold:float = 15
var player_in_cone:bool = false
# layer 2 == things that block vision, layer 16 player only
const vision_mask:int = pow(2, 2-1) + pow(2, 16-1)

func move_agent(delta:float, is_running:bool=false) -> void:
	#if not nav_agent.is_navigation_finished():
	var dest:Vector2 = nav_agent.get_next_path_position()
	var dir:Vector2 = dest - parent_node.position
	var n:float = 1
	if is_running:
		n = parent_node.run_speed_factor
	parent_node.position += dir.normalized() * parent_node.movement_speed * delta * n
	vision_cone.look_at(dest)
	animate_agent(dir, is_running)
	
func animate_agent(dir:Vector2, is_running:bool) -> void:
	if abs(dir.x) <= anim_threshold and abs(dir.y) <= anim_threshold:
		animation_tree["active"] = false
		return
	else:
		# start animation and set blend space to movement
		animation_tree["active"] = true
		var x:float = 1 if dir.x > 0 else -1
		var y:float = -1 if dir.y > 0 else 1
		if abs(dir.x) <= anim_threshold:
			x = 0
		if abs(dir.y) <= anim_threshold:
			y = 0
		animation_tree["parameters/blend_position"].x = x
		animation_tree["parameters/blend_position"].y = y

func is_player_spotted() -> bool:
	return parent_node.detection >= parent_node.max_detection - parent_node.detection_threshold
	
func is_player_hidden() -> bool:
	return parent_node.detection <= parent_node.min_detection + parent_node.detection_threshold

func is_player_visiable() -> bool:
	# check if player is colliding with area
	if player_in_cone:
		# area 2d uses a mask that only the player is on
		# check if a ray is unobstructed
		# check a physics process raycast to see if the player can be seen
		var space_state = parent_node.get_world_2d().direct_space_state
		# construct a ray from enemy position to player position, use the vision mask
		var query = PhysicsRayQueryParameters2D.create(parent_node.position, player.position, vision_mask)
		# run the ray cast
		var result = space_state.intersect_ray(query)
		# check the result
		if result and result.collider == player:
			parent_node.player_detected = true
			return true
	parent_node.player_detected = false
	return false


func _on_vision_cone_body_entered(body: Node2D) -> void:
	if body == player:
		player_in_cone = true


func _on_vision_cone_body_exited(body: Node2D) -> void:
	if body == player:
		player_in_cone = false
		
func on_state_transition(oldState:State, newState:State):
	super(oldState, newState)
	parent_node.state_label.text = str(newState.name)[0]
