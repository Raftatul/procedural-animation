@tool
class_name CameraController
extends Node3D


@export var sensitivity := 1.0
@export var arm_length := 1.0:
	set(value):
		arm_length = value
		spring_arm_3d.spring_length = value

@export var spring_arm_3d: SpringArm3D
@export var camera_3d: Camera3D

##Define the max angle in the local x axis, 0 is no limit
@export_range(0, 180) var max_x_angle := 90.0

##Define the max angle in the local y axis, 0 is no limit
@export_range(0, 180) var max_y_angle := 0.0


func _unhandled_input(event: InputEvent) -> void:
	if not camera_3d.current:
		return
		
	if event is InputEventMouseMotion:
		var movement = -event.relative * sensitivity
		
		rotate_y(movement.x)
		if max_y_angle != 0.0:
			rotation_degrees.y = clamp(rotation_degrees.y, - max_y_angle, max_y_angle)
		
		spring_arm_3d.rotate_x(movement.y)
		if max_x_angle != 0.0:
			spring_arm_3d.rotation_degrees.x = clamp(spring_arm_3d.rotation_degrees.x, -max_x_angle, max_x_angle)
