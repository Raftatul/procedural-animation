extends CharacterBody3D


@export var acceleration := 25.0
@export var decceleration := 25.0

var movement := Vector3.ZERO


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if movement == Vector3.ZERO:
		velocity = velocity.move_toward(Vector3(0.0, velocity.y, 0.0), decceleration * delta)
	else:
		velocity = velocity.move_toward(Vector3(movement.x, velocity.y, movement.z), acceleration * delta)

	move_and_slide()
