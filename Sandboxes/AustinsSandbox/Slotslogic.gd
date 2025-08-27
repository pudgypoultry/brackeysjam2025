extends Node2D

@export var cell_height: float = 100.0
@export var speed: float = 900.0

@onready var sprite: Sprite2D = $Sprite2D
var tween: Tween
var rolling := false

func set_symbol(i: int) -> void:
	var total := sprite.hframes * sprite.vframes
	if total > 0:
		sprite.frame = i % total

func start_roll() -> void:
	rolling = true
	sprite.position.y = 0.0	# start from origin inside the reel

func _process(delta: float) -> void:
	if not rolling:
		return
	sprite.position.y += speed * delta
	var limit := cell_height * 10.0
	if sprite.position.y > limit:
		sprite.position.y = 0.0

func stop_to_symbol(target_index: int, settle_time: float = 0.25) -> void:
	rolling = false
	set_symbol(target_index)
	if tween and tween.is_running():
		tween.kill()
	# 
	var final_y := -cell_height * -3

	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "position:y", final_y, settle_time)
