class_name Leg
extends Node3D

@export var active := true :
	set(value):
		active = value
		
		ik_target.active = value
		set_physics_process(value)

@export var step_ray: StepRay
@export var adjacent_leg: Leg
@export var opposite_leg: Leg

@export var ik: SkeletonIK3D
@export var ik_target: IKTarget

@export var step_height := 0.1

@export_group("Suspension")
@export var force := 1.0
@export var suspension_height := 3.0
@export var suspension_rest_length := 2.0
@export var suspension_strength := 1.0


@onready var force_ray: RayCast3D = $ForceRay


func _ready() -> void:
	ik_target.step_target = step_ray.step_target
	ik_target.adjacent_target = adjacent_leg.ik_target
	ik_target.opposite_target = opposite_leg.ik_target
	ik_target.step_height = step_height
	
	ik.start()


func _physics_process(delta: float) -> void:
	if !force_ray.is_colliding() or ik_target.is_stepping or global_basis.y.dot(Vector3.UP) < 0.0:
		return
	
	_suspension(delta)


func _suspension(delta: float) -> void:
	var hit_point := force_ray.get_collision_point()
	var distance := force_ray.global_position.distance_to(hit_point)
	
	var force_point = owner.global_basis * owner.to_local(force_ray.global_position)
	
	var spring_length = clamp(distance - suspension_height, 0.0, suspension_rest_length)
	var spring_force = suspension_strength * (suspension_rest_length - spring_length)
	var suspension_force = (1.0 / distance) * force * spring_force * delta
	
	owner.apply_force(Vector3.UP * suspension_force, force_point)
