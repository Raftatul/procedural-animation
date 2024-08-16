class_name Leg
extends Node3D


@export var step_ray: StepRay
@export var adjacent_leg: Leg
@export var opposite_leg: Leg

@export var ik: SkeletonIK3D
@export var ik_target: IKTarget

@export var force := 1.0
@export var step_height := 0.1

@onready var ray: RayCast3D = $ForceRay


func _ready() -> void:
	ik_target.step_target = step_ray.step_target
	ik_target.adjacent_target = adjacent_leg.ik_target
	ik_target.opposite_target = opposite_leg.ik_target
	ik_target.step_height = step_height
	
	ik.start()


func _physics_process(delta: float) -> void:
	var hit_point := ray.get_collision_point()
	if ray.is_colliding():
		var dis := ray.global_position.distance_to(hit_point)
		var force_point = owner.global_basis * owner.to_local(ray.global_position)
		
		owner.apply_force(Vector3.UP * (1.0 / dis) * force * delta, force_point)
