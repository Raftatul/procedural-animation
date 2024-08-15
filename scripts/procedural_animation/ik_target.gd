class_name IKTarget
extends Marker3D


signal target_reached

enum MOVEMENT_MODE {WALK, RUN}

@export var ray: RayCast3D

@export_group("Parameters")
@export var front_step_distance := 3.0
@export var tween_speed := 0.1

var step_target: Node3D
var adjacent_target: IKTarget
var opposite_target: IKTarget

var step_height := 1.0

var movement_mode := MOVEMENT_MODE.WALK

var is_stepping := false
var can_step := false


func _process(_delta: float) -> void:
	can_step = step_target.get_meta("is_on_ground", false)
	
	if !can_step:
		return
	
	if ray.is_colliding():
		var hit_point = ray.get_collision_point()
		
		if !is_stepping:
			global_position = hit_point


func _physics_process(_delta: float) -> void:
	if !can_step:
		global_position = global_position.lerp(step_target.global_position, tween_speed)
	
	var distance_to_target = abs(global_position.distance_to(step_target.global_position))
	
	if !distance_to_target > front_step_distance:
		return
	
	match movement_mode:
		MOVEMENT_MODE.WALK:
			_handle_walk_mode()
		MOVEMENT_MODE.RUN:
			_handle_run_mode()


func step() -> void:
	if !can_step:
		return
	
	var target_pos := step_target.global_position
	var half_way := (global_position + step_target.global_position) / 2.0
	
	is_stepping = true
	
	var t = get_tree().create_tween()
	t.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	t.tween_property(self, "global_position", half_way + owner.global_basis.y * step_height, tween_speed)
	t.tween_property(self, "global_position", target_pos, tween_speed)
	t.tween_callback(func(): is_stepping = false)
	t.tween_callback(func(): target_reached.emit())


func _handle_walk_mode() -> void:
	if !is_stepping and !adjacent_target.is_stepping:
		step()
		opposite_target.step()


func _handle_run_mode() -> void:
	if !is_stepping and !opposite_target.is_stepping:
		step()
		adjacent_target.step()
