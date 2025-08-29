extends Node2D

@export var animation_tree: AnimationTree
@export var parent_node:Node2D

@onready var state_manager: Node = $StateManager
@onready var idle: Node = $StateManager/Idle
@onready var searching: Node = $StateManager/Searching
@onready var chasing: Node = $StateManager/Chasing
@onready var waiting: Node = $StateManager/Waiting
@onready var detection_label: Label = $DetectionLabel
@onready var state_label: Label = $StateLabel
@onready var stealth_arrow: Node2D = $StealthArrow
