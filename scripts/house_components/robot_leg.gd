extends Node3D


@export var ik: SkeletonIK3D


func _ready() -> void:
	ik.start()
