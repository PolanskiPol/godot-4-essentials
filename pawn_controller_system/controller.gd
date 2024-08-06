class_name Controller
## Base class for all Controllers.
## A Controller is in charge of telling its [member pawn] what to do.
extends Node

## [Pawn] controlled by the Controller.
@export var pawn : Pawn

## Associated [ControlContext]
## The [ControlContext] acts as a shared resource of values where the Controller modifies them and the [Pawn] reads them to add functionality.
## Must be set in every class that inherits Controller, inside the method [method _init].
var context : ControlContext

func _init() -> void:
	context = ControlContext.new()
	
func _ready() -> void:
	if(pawn != null):
		posess(pawn)
	
func posess(pawn : Pawn) -> void:
	if(pawn != null):
		pawn.uncontrol()
	pawn.control(self)
	self.pawn = pawn
	
func unposess() -> void:
	pawn.uncontrol()
	pawn = null
	
## Virtual function, called on the associated [member pawn]
func input(event: InputEvent) -> void:
	pass
	
## Virtual function, called on the associated [member pawn]
func process(delta : float) -> void:
	pass
	
## Virtual function, called on the associated [member pawn]
func physics_process(delta : float) -> void:
	pass
