# meta-name: Pawn base template
# meta-description: Handle the data given by the Controller by reading the ControlContext
# meta-default: true
# meta-space-indent: 4

class_name _CLASS_
extends Pawn

# Virtual function. Called on input.
# Override to add your behaviour.
func input(event: InputEvent) -> void:
	pass
	
# Virtual function. Called every frame.
# Override to add your behaviour.
func process(delta : float) -> void:
	pass
	
# Virtual function. Called every physics frame.
# Override to add your behaviour.
func physics_process(delta : float) -> void:
	pass
