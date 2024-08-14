extends GameController


@export var body: RigidBody3D
@export var speed := 3.0
@export var turn_speed := 3.0

@onready var fl_leg: IKTarget = $"../Legs/FrontLeftLeg/IKTarget"
@onready var fr_leg: IKTarget = $"../Legs/FrontRightLeg/IKTarget"

@onready var bl_leg: IKTarget = $"../Legs/BackLeftLeg/IKTarget"
@onready var br_leg: IKTarget = $"../Legs/BackRightLeg/IKTarget"

var player_controller: GameController


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		switch_controller(player_controller)
	if event.is_action_pressed("run"):
		speed *= 2.0
		fl_leg.movement_mode = fl_leg.MOVEMENT_MODE.RUN
		fr_leg.movement_mode = fl_leg.MOVEMENT_MODE.RUN
		bl_leg.movement_mode = fl_leg.MOVEMENT_MODE.RUN
		br_leg.movement_mode = fl_leg.MOVEMENT_MODE.RUN
		
		fl_leg.front_step_distance *= 2.0
		fr_leg.front_step_distance *= 2.0
		bl_leg.front_step_distance *= 2.0
		br_leg.front_step_distance *= 2.0
	elif event.is_action_released("run"):
		speed /= 2.0
		fl_leg.movement_mode = fl_leg.MOVEMENT_MODE.WALK
		fr_leg.movement_mode = fl_leg.MOVEMENT_MODE.WALK
		bl_leg.movement_mode = fl_leg.MOVEMENT_MODE.WALK
		br_leg.movement_mode = fl_leg.MOVEMENT_MODE.WALK
		
		fl_leg.front_step_distance /= 2.0
		fr_leg.front_step_distance /= 2.0
		bl_leg.front_step_distance /= 2.0
		br_leg.front_step_distance /= 2.0


func _process(delta: float) -> void:
	handle_movement(delta)


func handle_movement(delta) -> void:
	var input := Input.get_axis("ui_up", "ui_down")
	var rot_input := Input.get_axis("ui_right", "ui_left")
	
	body.apply_central_force(input * body.global_basis.z * speed * delta)
	body.apply_torque(rot_input * body.global_basis.y * turn_speed * delta)


func _on_controller_interaction_interacted(controller: GameController) -> void:
	controller.switch_controller(self)
	player_controller = controller
