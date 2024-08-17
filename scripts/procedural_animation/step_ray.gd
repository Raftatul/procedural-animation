class_name StepRay
extends RayCast3D


@export var step_target: Node3D
@export var reset_target: Node3D

@export_range(-90.0, 90.0) var max_angle := 45.0

@onready var max_rad_angle := deg_to_rad(max_angle)

@onready var body: RigidBody3D = owner

var is_on_ground := false


func _physics_process(_delta: float) -> void:
	is_on_ground = is_colliding()
	step_target.set_meta("is_on_ground", is_on_ground)
	
	if is_on_ground:
		var hit_point = get_collision_point()
		var angle = get_collision_normal().angle_to(Vector3.UP)
		
		if angle < max_rad_angle or is_equal_approx(angle, max_rad_angle) or max_angle == 0:
			step_target.global_position = hit_point
	else:
		step_target.global_position = reset_target.global_position
