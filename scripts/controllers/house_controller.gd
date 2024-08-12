extends GameController


@export var body: Node3D
@export var speed := 3.0
@export var turn_speed := 3.0

var player_controller: GameController


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		switch_controller(player_controller)
	if event.is_action_pressed("run"):
		speed *= 2.0
	elif event.is_action_released("run"):
		speed /= 2.0


func _process(delta: float) -> void:
	handle_movement(delta)


func handle_movement(delta) -> void:
	var input := Input.get_axis("ui_up", "ui_down")
	var rot_input := Input.get_axis("ui_right", "ui_left")
	
	body.translate_object_local(Vector3(0, 0, input) * speed * delta)
	body.rotate_object_local(Vector3.UP, rot_input * turn_speed * delta)


func _on_controller_interaction_interacted(controller: GameController) -> void:
	controller.switch_controller(self)
	player_controller = controller
