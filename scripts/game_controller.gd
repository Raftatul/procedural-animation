class_name GameController
extends Node


signal control_stat_changed(value: bool)

@export var is_controlled := false:
	set(value):
		is_controlled = value
		control_stat_changed.emit(value)
		
		if value:
			process_mode = ProcessMode.PROCESS_MODE_INHERIT
		else:
			process_mode = ProcessMode.PROCESS_MODE_DISABLED


@export var camera: CameraController


func _ready() -> void:
	if not camera:
		camera = preload("res://scenes/camera_controller.tscn").instantiate()
		owner.add_child.call_deferred(camera)
	
	is_controlled = is_controlled
	
	camera.camera_3d.current = is_controlled


func switch_controller(target_controller: GameController):
	is_controlled = false
	target_controller.is_controlled = true
	
	camera.camera_3d.current = false
	target_controller.camera.camera_3d.current = true
