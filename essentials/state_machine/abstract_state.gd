@abstract
class_name AbstractState
extends Node

var state_machine : StateMachine
var blackboard : Dictionary[String, Variant]

@abstract
func _on_entered() -> void

@abstract
func _on_processed(delta : float) -> void

@abstract
func _on_exited() -> void
