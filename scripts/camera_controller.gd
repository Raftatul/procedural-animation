@tool
class_name CameraController
extends Node3D


@export var spring_arm_3d: SpringArm3D
@export var camera_3d: Camera3D

@export_group("Parameters")
@export var sensitivity := 1.0
@export var arm_length := 1.0:
	set(value):
		arm_length = value
		spring_arm_3d.spring_length = value

##Define the movement speed of the camera, 0 is instante movement
@export var move_speed := 0.0

##Define the max angle in the local x axis, 0 is no limit
@export_range(0, 180) var max_x_angle := 90.0

##Define the max angle in the local y axis, 0 is no limit
@export_range(0, 180) var max_y_angle := 0.0

var initial_pos := Vector3.ZERO


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	initial_pos = position
	top_level = true


func _unhandled_input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
	
	if not camera_3d.current:
		return
		
	if event is InputEventMouseMotion:
		var movement = -event.relative * sensitivity * get_process_delta_time()
		_rotate_camera(movement)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	var movement := Input.get_vector("camera_right", "camera_left", "camera_down", "camera_up") * delta
	_rotate_camera(movement)
	
	var target_pos = owner.global_position + initial_pos
	
	if move_speed == 0:
		global_position = target_pos
	else:
		global_position = global_position.lerp(target_pos, move_speed * delta)


func _rotate_camera(movement: Vector2) -> void:
	rotate_y(movement.x)
	if max_y_angle != 0.0:
		rotation_degrees.y = clamp(rotation_degrees.y, - max_y_angle, max_y_angle)
	
	spring_arm_3d.rotate_x(movement.y)
	if max_x_angle != 0.0:
		spring_arm_3d.rotation_degrees.x = clamp(spring_arm_3d.rotation_degrees.x, -max_x_angle, max_x_angle)
