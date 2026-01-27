class_name ControllerMovementConfig
extends Resource

@export_group("Speed")
@export var acceleration : float = 0.1
@export var speed : float = 5.0
@export var side_speed : float = 4.25
@export var backwards_speed : float = 3.5
@export var run_speed : float = 6.5
@export var crouch_speed : float = 2.0
@export var slow_speed : float = 3.25

@export_group("Jump")
@export var max_jumps : int = 1
@export var jump_force : float = 3.0
