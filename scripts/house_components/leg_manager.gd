extends Node


@export var step_container: Node3D


func _ready() -> void:
	for child in get_children():
		var ik_target: IKTarget = child.get_node("IKTarget")
		var step_child
