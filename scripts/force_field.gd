extends Area3D


@export var force := 10.0


func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if body.get_meta("is_ball", false):
			var direction_to_goal := body.global_position.direction_to($"../Area3D".global_position)
			
			body.apply_central_force(direction_to_goal * force * delta)
