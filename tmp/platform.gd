extends Node3D

@export var height_offset := 1.0
@export var speed := 5.0

@onready var fl_leg: IKTarget = $FrontLeftLeg/Marker3D
@onready var fr_leg: IKTarget = $FrontRightLeg/Marker3D

@onready var bl_leg: IKTarget = $BackLeftLeg/Marker3D
@onready var br_leg: IKTarget = $BackRightLeg/Marker3D


func _physics_process(delta: float) -> void:
	var plane1 = Plane(bl_leg.global_position, fl_leg.global_position, fr_leg.global_position)
	var plane2 = Plane(fr_leg.global_position, br_leg.global_position, bl_leg.global_position)
	var avg_normal = ((plane1.normal + plane2.normal) / 2.0).normalized()
	var target_basis := _basis_from_normal(avg_normal)
	
	basis = lerp(basis, target_basis, speed * delta).orthonormalized()
	
	var avg = (fl_leg.position + fr_leg.position + bl_leg.position + br_leg.position) / 4.0
	var target_pos = avg + basis.y * height_offset
	var distance := basis.y.dot(target_pos - position)
	position = lerp(position, position + basis.y * distance, speed * delta)


func _basis_from_normal(normal: Vector3) -> Basis:
	var result := Basis()
	
	result.x = normal.cross(basis.z)
	result.y = normal
	result.z = basis.x.cross(normal)
	
	result = result.orthonormalized()
	result.x *= scale.x
	result.y *= scale.y
	result.z *= scale.z
	
	return result
