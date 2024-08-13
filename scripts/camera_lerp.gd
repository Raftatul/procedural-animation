extends RemoteTransform3D


@export var speed := 1.0


func _physics_process(delta: float) -> void:
	global_position = global_position.lerp(owner.global_position, speed)
