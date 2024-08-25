class_name EnergyRecepteur
extends Area3D


signal received_energy

@export var battery: Battery


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if body is EnergyCell:
		received_energy.emit()
		battery.add_charge(body.energy_amount)
		body.queue_free()
