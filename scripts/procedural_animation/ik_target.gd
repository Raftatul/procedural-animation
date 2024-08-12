class_name IKTarget
extends RigidBody3D


@export var step_target: Node3D

@export var front_step_distance := 3.0
@export var step_height := 1.0
@export var tween_speed := 0.1

@export var adjacent_target: IKTarget
@export var opposite_target: IKTarget

var is_stepping := false


func _physics_process(_delta: float) -> void:
	if !is_stepping and !adjacent_target.is_stepping and abs(global_position.distance_to(step_target.global_position)) > front_step_distance:
		step()
		opposite_target.step()


func step() -> void:
	var target_pos := step_target.global_position
	var half_way := (global_position + step_target.global_position) / 2.0
	
	is_stepping = true
	
	var t = get_tree().create_tween()
	t.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	t.tween_property(self, "global_position", half_way + owner.global_basis.y * step_height, tween_speed)
	t.tween_property(self, "global_position", target_pos + Vector3.UP * 0.1, tween_speed)
	t.tween_callback(func(): is_stepping = false)
