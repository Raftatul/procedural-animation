class_name Battery
extends Node


signal max_charge_changed(value: float)
signal charge_changed(value: float)

signal power_on
signal power_off

@export var max_charge := 100.0 :
	set(value):
		max_charge = value
		max_charge_changed.emit(max_charge)

var charge := 0.0 :
	set(value):
		var pre_charge = charge
		charge = clamp(value, 0.0, max_charge)
		
		if charge != pre_charge:
			charge_changed.emit(charge)
		
		if charge == 0.0 and pre_charge != 0.0:
			power_off.emit()
		elif charge != 0.0 and pre_charge == 0.0:
			power_on.emit()

var consumption := 0.0


func _ready() -> void:
	max_charge = max_charge
	charge = max_charge


func _physics_process(delta: float) -> void:
	consume_charge(consumption * delta)


func add_charge(value: float) -> void:
	charge += value


func consume_charge(value: float) -> void:
	charge -= value
