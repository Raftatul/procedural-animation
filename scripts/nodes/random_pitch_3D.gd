class_name RandomPitch3D
extends AudioStreamPlayer3D


func play_stream(from_position: float = 0.0) -> void:
	pitch_scale = randf_range(0.8, 1.2)
	play(from_position)
