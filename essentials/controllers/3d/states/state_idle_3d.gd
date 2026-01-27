class_name StateIdle3D
extends AbstractState

func _on_entered() -> void:
	pass


func _on_processed(delta : float) -> void:
	var controller : AbstractController3D = blackboard.controller as AbstractController3D
	if(controller.velocity.y < 0.0):
		state_machine.set_state(StateJumping3D.new())
	elif(controller.velocity.y > 0.0):
		state_machine.set_state(StateFalling3D.new())
	elif(controller.velocity.x != 0.0):
		state_machine.set_state(StateMoving3D.new())


func _on_exited() -> void:
	pass
