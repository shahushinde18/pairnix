extends Control

@onready var sound_check_button: Button = $SettingsContainer/SoundCheckButton
@onready var back_button: Button = $SettingsContainer/BackButton
@onready var button_click_sound: AudioStreamPlayer = $ButtonClickSound


func _ready() -> void:
	sound_check_button.pressed.connect(_on_sound_check_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)

	update_sound_button()


func update_sound_button() -> void:
	var sound_enabled := SaveManager.get_sound_enabled()

	if sound_enabled:
		sound_check_button.text = "ON"
	else:
		sound_check_button.text = "OFF"


func _on_sound_check_button_pressed() -> void:
	button_click_sound.play()

	var current_state := SaveManager.get_sound_enabled()
	var new_state := not current_state

	SaveManager.save_sound_enabled(new_state)
	AudioManager.set_sound_enabled(new_state)

	update_sound_button()

	print("SOUND ENABLED: ", new_state)


func _on_back_button_pressed() -> void:
	button_click_sound.play()

	print("SETTINGS BACK BUTTON PRESSED")

	await get_tree().create_timer(0.15).timeout

	get_tree().change_scene_to_file(
		"res://Scenes/MainMenu/MainMenu.tscn"
	)
