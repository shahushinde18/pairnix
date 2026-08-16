extends Control

@onready var sound_check_button: Button = $SettingsContainer/SoundCheckButton
@onready var music_check_button: Button = $SettingsContainer/MusicCheckButton
@onready var back_button: Button = $SettingsContainer/BackButton
@onready var button_click_sound: AudioStreamPlayer = $ButtonClickSound


func _ready() -> void:
	sound_check_button.pressed.connect(_on_sound_check_button_pressed)
	music_check_button.pressed.connect(_on_music_check_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)

	update_sound_button()
	update_music_button()


func update_sound_button() -> void:
	var sound_enabled := SaveManager.get_sound_enabled()

	if sound_enabled:
		sound_check_button.text = "ON"
	else:
		sound_check_button.text = "OFF"


func update_music_button() -> void:
	var music_enabled := SaveManager.get_music_enabled()

	if music_enabled:
		music_check_button.text = "ON"
	else:
		music_check_button.text = "OFF"


func _on_sound_check_button_pressed() -> void:
	button_click_sound.play()

	var current_state := SaveManager.get_sound_enabled()
	var new_state := not current_state

	SaveManager.save_sound_enabled(new_state)
	AudioManager.set_sound_enabled(new_state)

	update_sound_button()


func _on_music_check_button_pressed() -> void:
	button_click_sound.play()

	var current_state := SaveManager.get_music_enabled()
	var new_state := not current_state

	SaveManager.save_music_enabled(new_state)
	AudioManager.set_music_enabled(new_state)

	update_music_button()


func _on_back_button_pressed() -> void:
	button_click_sound.play()

	await get_tree().create_timer(0.15).timeout

	get_tree().change_scene_to_file(
		"res://Scenes/MainMenu/MainMenu.tscn"
	)
