class_name Pawn
## Base class for all Pawns.
## A Pawn is a [Node] that can be controlled by either a player or AI.
## All Pawns must extend from this base class to manage the inputs of the [Controller]
extends Node

## Associated [ControlContext]
## The [ControlContext] acts as a shared resource of values where the [Controller] modifies them and the Pawn reads them to add functionality.
var context : ControlContext

## Associated [Controller].
## The [Controller] is in charge of reading and handling inputs for the Pawn to react.
var _controller : Controller

func control(controller : Controller):
	if(_controller != null): return
	_controller = controller
	context = controller.context
	
func uncontrol() -> void:
	_controller = null
	context = null
	
## Virtual function
func input(event: InputEvent) -> void:
	pass
	
## Virtual function
func process(delta : float) -> void:
	pass
	
## Virtual function
func physics_process(delta : float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if(_controller != null):
		_controller.input(event)
	input(event)
	
func _process(delta: float) -> void:
	if(_controller != null):
		_controller.process(delta)
	process(delta)
	
func _physics_process(delta: float) -> void:
	if(_controller != null):
		_controller.physics_process(delta)
	physics_process(delta)
