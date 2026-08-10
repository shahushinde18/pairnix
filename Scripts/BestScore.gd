extends Control

@onready var best_score_label: Label = $ScoreContainer/BestScoreLabel
@onready var back_button: Button = $ScoreContainer/BackButton


func _ready() -> void:
	print("BEST SCORE SCREEN READY")

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
	print("BEST SCORE BACK BUTTON PRESSED")

	get_tree().change_scene_to_file(
		"res://Scenes/MainMenu/MainMenu.tscn"
	)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("MOUSE CLICK: ", event.position)

			if back_button.get_global_rect().has_point(event.position):
				print("CLICK IS INSIDE BACK BUTTON")

				get_viewport().set_input_as_handled()

				get_tree().change_scene_to_file(
					"res://Scenes/MainMenu/MainMenu.tscn"
				)
