extends RayCast3D


@export var step_target: Node3D
@export var max_angle := 45.0

@onready var max_rad_angle := deg_to_rad(max_angle)


func _physics_process(_delta: float) -> void:
	var hit_point = get_collision_point()
	var angle = get_collision_normal().angle_to(Vector3.UP)

	if hit_point and angle < max_rad_angle or is_equal_approx(angle, max_rad_angle) or max_angle == 0:
		step_target.global_position = hit_point
