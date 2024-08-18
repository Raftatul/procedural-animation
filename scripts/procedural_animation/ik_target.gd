class_name IKTarget
extends Marker3D


signal target_reached

enum MOVEMENT_MODE {WALK, RUN}

@export var ray: RayCast3D

@export_group("Parameters")
@export var front_step_distance := 3.0
@export var side_step_distance := 3.0
@export var tween_speed := 0.1

var step_target: Node3D
var adjacent_target: IKTarget
var opposite_target: IKTarget

var step_height := 1.0

var movement_mode := MOVEMENT_MODE.WALK

var is_stepping := false

var _can_step := false
var _in_step_delay := false


func _process(_delta: float) -> void:
	_can_step = step_target.get_meta("is_on_ground", false)
	
	if !_can_step:
		return
	
	if ray.is_colliding():
		var hit_point = ray.get_collision_point()
		
		if !is_stepping:
			global_position = hit_point


func _physics_process(_delta: float) -> void:
	if !_can_step:
		global_position = global_position.lerp(step_target.global_position, tween_speed)
	
	var local_pos = owner.to_local(global_position)
	var target_local_pos = owner.to_local(step_target.global_position)
	
	var front_distance = abs(local_pos.z - target_local_pos.z)
	var side_distance = abs(local_pos.x - target_local_pos.x)
	var max_distance = global_position.distance_to(step_target.global_position)
	
	var front_condition = !front_distance > front_step_distance
	var side_condition = !side_distance > side_step_distance
	var max_condition = !max_distance > max(front_step_distance, side_step_distance)
	
	DebugDraw3D.draw_arrow(global_position, global_position + -owner.global_basis.z * front_distance, Color.GREEN, 0.25)
	DebugDraw3D.draw_arrow(global_position, global_position + -owner.global_basis.x * side_distance, Color.GREEN, 0.25)
	
	if front_condition and side_condition and max_condition:
		return
	
	match movement_mode:
		MOVEMENT_MODE.WALK:
			_handle_walk_mode()
		MOVEMENT_MODE.RUN:
			_handle_run_mode()


func step() -> void:
	if !_can_step or _in_step_delay:
		return
	
	var target_pos := step_target.global_position
	var half_way := (global_position + step_target.global_position) / 2.0
	
	is_stepping = true
	_in_step_delay = true
	
	var t = get_tree().create_tween()
	t.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	
	t.tween_property(self, "global_position", half_way + owner.global_basis.y * step_height, tween_speed)
	t.tween_property(self, "global_position", target_pos, tween_speed)
	t.tween_callback(func(): is_stepping = false)
	t.tween_callback(func(): target_reached.emit())
	t.tween_interval(tween_speed)
	t.tween_callback(func(): _in_step_delay = false)


func _handle_walk_mode() -> void:
	if !is_stepping and !adjacent_target.is_stepping:
		step()
		opposite_target.step()


func _handle_run_mode() -> void:
	if !is_stepping and !opposite_target.is_stepping:
		step()
		adjacent_target.step()
