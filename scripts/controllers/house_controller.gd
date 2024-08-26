extends GameController


@export var body: RigidBody3D
@export var speed := 3.0
@export var turn_speed := 3.0
@export var linear_damping := 0.0
@export var angular_damping := 0.0

@onready var fl_leg: IKTarget = $"../Legs/FrontLeftLeg/IKTarget"
@onready var fr_leg: IKTarget = $"../Legs/FrontRightLeg/IKTarget"

@onready var bl_leg: IKTarget = $"../Legs/BackLeftLeg/IKTarget"
@onready var br_leg: IKTarget = $"../Legs/BackRightLeg/IKTarget"

var player_controller: GameController


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and player_controller:
		switch_controller(player_controller)
	if event.is_action_pressed("run"):
		speed *= 2.0
		fl_leg.movement_mode = fl_leg.MOVEMENT_MODE.RUN
		fr_leg.movement_mode = fl_leg.MOVEMENT_MODE.RUN
		bl_leg.movement_mode = fl_leg.MOVEMENT_MODE.RUN
		br_leg.movement_mode = fl_leg.MOVEMENT_MODE.RUN
	elif event.is_action_released("run"):
		speed /= 2.0
		fl_leg.movement_mode = fl_leg.MOVEMENT_MODE.WALK
		fr_leg.movement_mode = fl_leg.MOVEMENT_MODE.WALK
		bl_leg.movement_mode = fl_leg.MOVEMENT_MODE.WALK
		br_leg.movement_mode = fl_leg.MOVEMENT_MODE.WALK
	elif event.is_action_pressed("gear_up"):
		body.gear_force += 0.1
	elif event.is_action_pressed("gear_down"):
		body.gear_force -= 0.1

func _process(delta: float) -> void:
	handle_movement(delta)


func handle_movement(delta) -> void:
	var input_z := Input.get_axis("move_forward", "move_backward")
	var input_x := Input.get_axis("move_left", "move_right")
	var rot_input := Input.get_axis("ui_right", "ui_left")
	
	var force_multiplier_z: float = 1.0 + owner.global_basis.z.dot(Vector3.DOWN) * input_z
	var force_multiplier_x: float = 1.0 + owner.global_basis.x.dot(Vector3.DOWN) * input_x
	
	var move_force_z = body.global_basis.z * speed * force_multiplier_z * delta
	var move_force_x = body.global_basis.x * speed * force_multiplier_x * delta
	
	var rotation_torque = body.global_basis.y * turn_speed * delta
	
	var leg_force_multiplier := _get_leg_on_ground_percent()
	
	body.linear_damp = linear_damping * leg_force_multiplier
	body.angular_damp = angular_damping * leg_force_multiplier
	
	body.apply_central_force(input_z * move_force_z * leg_force_multiplier * body.gear_force)
	body.apply_central_force(input_x * move_force_x * leg_force_multiplier * body.gear_force)
	
	body.apply_torque(rot_input * rotation_torque * leg_force_multiplier * body.gear_force)


func _get_leg_on_ground_percent() -> float:
	var leg_on_ground_count := 0
	
	if fl_leg.is_target_on_ground: leg_on_ground_count += 1
	if fr_leg.is_target_on_ground: leg_on_ground_count += 1
	if bl_leg.is_target_on_ground: leg_on_ground_count += 1
	if br_leg.is_target_on_ground: leg_on_ground_count += 1
	
	return leg_on_ground_count / 4.0


func _on_controller_interaction_interacted(controller: GameController) -> void:
	controller.switch_controller(self)
	player_controller = controller


func _on_health_die() -> void:
	set_process(false)
