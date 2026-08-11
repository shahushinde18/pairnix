extends Node

var sound_enabled := true


func _ready() -> void:
	sound_enabled = SaveManager.get_sound_enabled()
	update_audio()


func set_sound_enabled(enabled: bool) -> void:
	sound_enabled = enabled
	update_audio()


func update_audio() -> void:
	var master_bus := AudioServer.get_bus_index("Master")

	if master_bus == -1:
		return

	AudioServer.set_bus_mute(master_bus, not sound_enabled)
