@abstract
class_name AbstractController3D
extends CharacterBody3D

enum YAxisStatus {
	STANDING,
	CROUCHING,
	JUMPING,
	FALLING
}

enum XAxisStatus {
	STOPPED,
	WALKING,
	WALKING_SLOW,
	RUNNING
}

@export var input_config : ControllerInputConfig
@export var movement_config : ControllerMovementConfig

@onready var x_axis_status : XAxisStatus = XAxisStatus.STOPPED
@onready var y_axis_status : YAxisStatus = YAxisStatus.STANDING
@onready var y_speed : float = 0.0
@onready var jumps : int = movement_config.max_jumps

var active : bool
