class_name RandomPitch3D
extends AudioStreamPlayer3D


@export var audio_library: AudioLibrary
@export var custom_max_polyphonic := 32


func _ready() -> void:
	stream = AudioStreamPolyphonic.new()
	stream.polyphony = custom_max_polyphonic


func play_stream(tag:String, from_position: float = 0.0) -> void:
	pitch_scale = randf_range(0.8, 1.2)
	
	if !playing: play()
	
	var audio_stream := audio_library.get_audio_stream(tag)
	var polyphonic_stream_playback := self.get_stream_playback()
	polyphonic_stream_playback.play_stream(audio_stream)
