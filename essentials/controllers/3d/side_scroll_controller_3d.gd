class_name SideScrollController3D
extends AbstractController3D

signal look_direction_changed(direction : Direction)

enum Direction {
	NONE,
	LEFT,
	RIGHT
}

@onready var speed : float = movement_config.speed
@onready var look_direction : Direction = Direction.NONE :
	set(new_look_direction):
		if(look_direction == new_look_direction): return

		look_direction = new_look_direction
		look_direction_changed.emit(new_look_direction)


func _on_ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if(Input.is_action_pressed(input_config.input_run)):
		speed = movement_config.run_speed
	elif(Input.is_action_pressed(input_config.input_slow)):
		speed = movement_config.slow_speed
	else:
		speed = movement_config.speed

	if(Input.is_action_just_pressed(input_config.input_jump)):
		input_bufferer.buffer(
			input_config.input_jump,
			func() -> void:
				jumps -= 1
				velocity.y = movement_config.jump_force
				,
			func() -> bool:
				return jumps > 0
		)

	var direction : float = Input.get_axis(input_config.input_left, input_config.input_right)

	if(direction < 0.0):
		look_direction = Direction.LEFT
	elif(direction > 0.0):
		look_direction = Direction.RIGHT

	if not is_on_floor():
		velocity += get_gravity() * delta

	# Control de altura del salto: si sueltas el botón mientras subes, reduces la velocidad
	if Input.is_action_just_released(input_config.input_jump) and velocity.y > 0:
		velocity.y *= 0.5

	velocity.x = move_toward(velocity.x, direction * speed, movement_config.acceleration)

	move_and_slide()

	if(is_on_floor()):
		jumps = movement_config.max_jumps
