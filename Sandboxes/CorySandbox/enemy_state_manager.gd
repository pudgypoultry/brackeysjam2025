extends StateManager

@export var player:Node2D
@export var detection_meter:float
@export var vision_cone:Area2D
@onready var enemy: Node2D = $".."
# layer 2 == things that block vision, layer 16 player only
const vision_mask:int = pow(2, 2) + pow(2, 16)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func is_player_visiable() -> bool:
	# check if player is colliding with area
	if vision_cone.has_overlapping_bodies():
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
			print("player spotted")
			return true
	return false
