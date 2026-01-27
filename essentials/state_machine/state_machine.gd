class_name StateMachine
extends Node

@export var initial_state : AbstractState
@export var blackboard : Dictionary[String, Variant]

@onready var _current_state : AbstractState = initial_state

func _ready() -> void:
	_current_state._on_entered()


func _process(delta: float) -> void:
	_current_state._on_processed(delta)


func set_state(state : AbstractState) -> void:
	if(_current_state != null):
		_current_state._on_exited()
		_current_state.queue_free()

	_current_state = state
	_current_state.state_machine = self
	_current_state.blackboard = blackboard
	add_child(_current_state)
	_current_state._on_entered()
