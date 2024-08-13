class_name IKTarget
extends Marker3D


enum MOVEMENT_MODE {WALK, RUN}

const RAY_LENGTH = 1000

@export var step_target: Node3D
@export var ray: RayCast3D

@export_group("IKs")
@export var adjacent_target: IKTarget
@export var opposite_target: IKTarget

@export_group("Parameters")
@export var front_step_distance := 3.0
@export var step_height := 1.0
@export var tween_speed := 0.1

var is_stepping := false
var movement_mode := MOVEMENT_MODE.WALK


func _process(_delta: float) -> void:
	var hit_point = ray.get_collision_point()
	if hit_point and !is_stepping:
		global_position = hit_point


func _physics_process(_delta: float) -> void:
	match movement_mode:
		MOVEMENT_MODE.WALK:
			_handle_walk_mode()
		MOVEMENT_MODE.RUN:
			_handle_run_mode()


func step() -> void:
	var target_pos := step_target.global_position
	var half_way := (global_position + step_target.global_position) / 2.0
	
	is_stepping = true
	
	var t = get_tree().create_tween()
	t.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	t.tween_property(self, "global_position", half_way + owner.global_basis.y * step_height, tween_speed)
	t.tween_property(self, "global_position", target_pos, tween_speed)
	t.tween_callback(func(): is_stepping = false)


func _handle_walk_mode() -> void:
	if !is_stepping and !adjacent_target.is_stepping and abs(global_position.distance_to(step_target.global_position)) > front_step_distance:
		step()
		opposite_target.step()


func _handle_run_mode() -> void:
	if !is_stepping and !opposite_target.is_stepping and abs(global_position.distance_to(step_target.global_position)) > front_step_distance:
		step()
		adjacent_target.step()
