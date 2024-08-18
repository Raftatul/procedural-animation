extends Node3D

#@export var height_offset := 1.0
@export var align_speed := 5.0

@onready var fl_leg: IKTarget = $Legs/FrontLeftLeg/IKTarget
@onready var fr_leg: IKTarget = $Legs/FrontRightLeg/IKTarget

@onready var bl_leg: IKTarget = $Legs/BackLeftLeg/IKTarget
@onready var br_leg: IKTarget = $Legs/BackRightLeg/IKTarget


func _physics_process(delta: float) -> void:
	for step in get_tree().get_nodes_in_group("step_ray"):
		if !step.is_on_ground:
			return
	
	var plane1 = Plane(bl_leg.global_position, fl_leg.global_position, fr_leg.global_position)
	var plane2 = Plane(fr_leg.global_position, br_leg.global_position, bl_leg.global_position)
	var avg_normal = ((plane1.normal + plane2.normal) / 2.0).normalized()
	var target_basis := _basis_from_normal(avg_normal)
	
	basis = lerp(basis, target_basis, align_speed * delta).orthonormalized()
	#
	#var avg = (fl_leg.position + fr_leg.position + bl_leg.position + br_leg.position) / 4.0
	#var target_pos = avg + basis.y * height_offset
	#var distance := basis.y.dot(target_pos - position)
	#position = lerp(position, position + basis.y * distance, align_speed * delta)


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


func _on_area_3d_body_entered(body: Node3D) -> void:
	for leg in $Legs.get_children():
		leg.active = false
	
	$CustomAudioStreamPlayer3D.play_stream("Hurt")
