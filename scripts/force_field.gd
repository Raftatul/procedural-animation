extends Area3D


@export var attraction_point: Node3D
@export var force := 10.0


func _physics_process(_delta: float) -> void:
	for body in get_overlapping_bodies():
		if body.get_meta("is_ball", false):
			var target_pos = attraction_point.global_position
			var direction_to_goal := body.global_position.direction_to(target_pos)
			var distance = body.global_position.distance_to(target_pos)
			
			body.apply_central_force(direction_to_goal * (force / distance))
