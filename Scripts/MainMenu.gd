extends Control

@onready var play_button: Button = $MenuContainer/ButtonsContainer/PlayButton
@onready var best_score_button: Button = $MenuContainer/ButtonsContainer/BestScoreButton
@onready var settings_button: Button = $MenuContainer/ButtonsContainer/SettingsButton
@onready var button_click_sound: AudioStreamPlayer = $ButtonClickSound

func _ready() -> void:
	play_button.pressed.connect(_on_play_button_pressed)
	best_score_button.pressed.connect(_on_best_score_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)


func _on_play_button_pressed() -> void:
	button_click_sound.play()

	print("PLAY BUTTON PRESSED")

	await get_tree().create_timer(0.15).timeout

	get_tree().change_scene_to_file(
		"res://Scenes/Game/Game.tscn"
	)


func _on_best_score_button_pressed() -> void:
	button_click_sound.play()

	print("BEST SCORE BUTTON PRESSED")

	await get_tree().create_timer(0.15).timeout

	get_tree().change_scene_to_file(
		"res://Scenes/BestScore/BestScore.tscn"
	)


func _on_settings_button_pressed() -> void:
	button_click_sound.play()

	print("SETTINGS BUTTON PRESSED")

	await get_tree().create_timer(0.15).timeout

	get_tree().change_scene_to_file(
		"res://Scenes/Settings/Settings.tscn"
	)
