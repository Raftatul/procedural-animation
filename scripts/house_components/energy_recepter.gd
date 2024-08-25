class_name EnergyRecepteur
extends Area3D


signal received_energy

@export var battery: Battery


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(body: Area3D) -> void:
	if body is EnergyCell:
		received_energy.emit()
		battery.add_charge(body.energy_amount)
		body.queue_free()
