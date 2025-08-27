extends Node2D

@export var cell_height: float = 100.0 
@export var speed:float = 900.0

@onready var sprite: Sprite2D= $Sprite2D
var tween: Tween
var rolling: bool = false

func set_symbol(i:int)->void: 
	var total:int = max(1, sprite.hframes * sprite.vframes)
	sprite.frame = i % total
func start_roll()->void:
	rolling = true

	
func _process(delta:float)->void:
	if !rolling:return
	position.y += speed * delta
	if position.y > cell_height *10.0:
		position.y -=cell_height * 10.0
		
func stop_to_symbol(target_index:int, settle_time:float = 0.35) ->void:
	rolling=false
	set_symbol(target_index)
	var snapped: float=round(position.y / cell_height) * cell_height
	if tween and tween.is_running(): tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"position:y", snapped, settle_time)
	
