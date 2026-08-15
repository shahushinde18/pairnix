extends Control

@onready var best_score_label: Label = $ScoreContainer/BestScoreLabel
@onready var back_button: Button = $ScoreContainer/BackButton
@onready var button_click_sound: AudioStreamPlayer = $ButtonClickSound


func _ready() -> void:

	back_button.mouse_filter = Control.MOUSE_FILTER_STOP
	back_button.disabled = false

	update_best_score()

	back_button.pressed.connect(_on_back_button_pressed)


func update_best_score() -> void:
	var best_score := SaveManager.get_best_score()

	if best_score == 0:
		best_score_label.text = "Best Moves: --"
	else:
		best_score_label.text = "Best Moves: %d" % best_score


func _on_back_button_pressed() -> void:
	button_click_sound.play()

	await get_tree().create_timer(0.15).timeout

	get_tree().change_scene_to_file(
		"res://Scenes/MainMenu/MainMenu.tscn"
	)
