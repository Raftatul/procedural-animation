extends GameController


@export var body: CharacterBody3D
@export var camera_container: Node3D

@export var move_speed := 5.0

@onready var ray_cast_3d: RayCast3D = $"../CameraController/SpringArm3D/RayCast3D"


func _enter_tree() -> void:
	control_stat_changed.connect(func(_value: bool): body.movement = Vector3.ZERO)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		_interact()
	if event.is_action_pressed("jump"):
		body.velocity.y += 5.0


func _physics_process(_delta: float) -> void:
	var ray_collider := ray_cast_3d.get_collider()
	
	$"../CanvasLayer/Label".text = ""
	
	if ray_collider:
		if ray_collider is Interactable:
			$"../CanvasLayer/Label".text = ray_collider.get_prompt()
	
	_handle_movement()


func _interact():
	var ray_collider := ray_cast_3d.get_collider()
	
	if ray_collider:
		if ray_collider is Interactable:
			ray_collider.interact(self)


func _handle_movement():
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	body.movement = camera_container.global_basis * Vector3(direction.x, 0.0, direction.y) * move_speed
