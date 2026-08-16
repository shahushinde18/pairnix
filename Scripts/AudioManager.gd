extends Node

var sound_enabled := true
var music_enabled := true

var music_player: AudioStreamPlayer


func _ready() -> void:
	sound_enabled = SaveManager.get_sound_enabled()
	music_enabled = SaveManager.get_music_enabled()

	music_player = AudioStreamPlayer.new()
	add_child(music_player)

	music_player.stream = preload("res://Assets/Audio/background_music.mp3")
	music_player.finished.connect(_on_music_finished)

	update_audio()

	if music_enabled:
		play_music()


func set_sound_enabled(enabled: bool) -> void:
	sound_enabled = enabled
	SaveManager.save_sound_enabled(enabled)
	update_audio()


func set_music_enabled(enabled: bool) -> void:
	music_enabled = enabled
	SaveManager.save_music_enabled(enabled)

	if music_enabled:
		play_music()
	else:
		stop_music()


func update_audio() -> void:
	var master_bus := AudioServer.get_bus_index("Master")

	if master_bus == -1:
		return

	AudioServer.set_bus_mute(master_bus, not sound_enabled)


func play_music() -> void:
	if music_player == null:
		return

	if music_player.playing:
		return

	music_player.play()


func stop_music() -> void:
	if music_player == null:
		return

	music_player.stop()


func _on_music_finished() -> void:
	if music_enabled:
		music_player.play()
