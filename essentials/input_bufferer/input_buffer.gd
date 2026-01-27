class_name InputBuffer
extends RefCounted

var frame : int
var input : String
var action : Callable
var condition : Callable

func _init(input : String, action : Callable, condition : Callable) -> void:
	self.frame = Engine.get_frames_drawn()
	self.input = input
	self.action = action
	self.condition = condition
