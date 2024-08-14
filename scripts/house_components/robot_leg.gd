extends Node3D


@export var ik: SkeletonIK3D

@export var force := 1.0

@onready var ray: RayCast3D = $ForceRay


func _ready() -> void:
	ik.start()


func _physics_process(delta: float) -> void:
	var hit_point := ray.get_collision_point()
	if ray.is_colliding():
		var dis := ray.global_position.distance_to(hit_point)
		var force_point = owner.global_basis * owner.to_local(ray.global_position)
		
		owner.apply_force(Vector3.UP * (1.0 / dis) * force * delta, force_point)
