extends Control

const CARD_SCENE := preload("res://Scenes/Cards/Card.tscn")
const TOTAL_PAIRS := 6

const CARD_TEXTURES := [
	preload("res://Assets/Images/Cards/lion.png"),
	preload("res://Assets/Images/Cards/rocket.png"),
	preload("res://Assets/Images/Cards/diamond.png"),
	preload("res://Assets/Images/Cards/lightning.png"),
	preload("res://Assets/Images/Cards/moon.png"),
	preload("res://Assets/Images/Cards/flame.png")
]

@onready var card_grid: GridContainer = $CardGrid
@onready var pairs_label: Label = $PairsLabel
@onready var moves_label: Label = $MovesLabel
@onready var game_timer: Timer = $Timer
@onready var time_label: Label = $TimeLabel

@onready var completion_panel: Panel = $CompletionPanel
@onready var completion_result: Label = $CompletionPanel/CompletionBox/CompletionResult
@onready var play_again_button: Button = $CompletionPanel/CompletionBox/PlayAgainButton
@onready var main_menu_button: Button = $CompletionPanel/CompletionBox/MainMenuButton
@onready var button_click_sound: AudioStreamPlayer = $ButtonClickSound
@onready var match_success_sound: AudioStreamPlayer = $MatchSuccessSound
@onready var wrong_match_sound: AudioStreamPlayer = $WrongMatchSound
@onready var game_complete_sound: AudioStreamPlayer = $GameCompleteSound
@onready var best_score_result: Label = $CompletionPanel/CompletionBox/BestScoreResult
@onready var pause_panel: Panel = $PausePanel

var cards: Array[Control] = []

var first_card: Control = null
var second_card: Control = null

var input_locked := false
var moves := 0
var matched_pairs := 0
var elapsed_time := 0


func _ready() -> void:
	completion_panel.visible = false

	play_again_button.pressed.connect(_on_play_again_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)

	game_timer.timeout.connect(_on_game_timer_timeout)
	game_timer.start()

	update_time_label()
	update_labels()
	create_cards()


func update_labels() -> void:
	pairs_label.text = "Pairs: %d/%d" % [matched_pairs, TOTAL_PAIRS]
	moves_label.text = "Moves: %d" % moves


func update_time_label() -> void:
	var minutes := elapsed_time / 60
	var seconds := elapsed_time % 60

	time_label.text = "Time: %02d:%02d" % [minutes, seconds]


func create_cards() -> void:
	var card_ids: Array[int] = []

	for id in range(TOTAL_PAIRS):
		card_ids.append(id)
		card_ids.append(id)

	card_ids.shuffle()

	for id in card_ids:
		var card = CARD_SCENE.instantiate()

		card_grid.add_child(card)

		card.setup_card(id, CARD_TEXTURES[id])
		card.card_pressed.connect(_on_card_pressed)

		cards.append(card)


func set_cards_enabled(enabled: bool) -> void:
	for card in cards:
		if not card.is_matched:
			card.card_button.disabled = not enabled


func _on_card_pressed(card: Control) -> void:
	# Don't accept any input while two cards are being compared.
	if input_locked:
		return

	# Matched cards cannot be selected again.
	if card.is_matched:
		return

	# First card
	if first_card == null:
		first_card = card
		return

	# Same card cannot be selected twice.
	if card == first_card:
		return

	# Second card
	second_card = card

	moves += 1
	update_labels()

	# Lock ALL cards immediately.
	input_locked = true
	set_cards_enabled(false)

	# Keep local references to the pair being compared.
	var card_a: Control = first_card
	var card_b: Control = second_card

	# Clear the selection references.
	first_card = null
	second_card = null

	# MATCH
	if card_a.card_id == card_b.card_id:
		print("MATCH FOUND - Pair ID: ", card_a.card_id)
		
		match_success_sound.play()
		
		card_a.set_matched()
		card_b.set_matched()

		matched_pairs += 1
		update_labels()

		print("MATCHED PAIRS: ", matched_pairs, " / ", TOTAL_PAIRS)

		# Re-enable remaining unmatched cards.
		input_locked = false
		set_cards_enabled(true)

		if matched_pairs == TOTAL_PAIRS:
			game_completed()

	# NO MATCH
	else:
		print("NO MATCH - Pair IDs: ", card_a.card_id, " and ", card_b.card_id)
		
		# Keep both cards visible for 0.8 seconds.
		await get_tree().create_timer(0.8).timeout

		wrong_match_sound.play()
		
		# Hide ONLY the two cards that were compared.
		card_a.hide_card()
		card_b.hide_card()

		# Now allow the player to select another pair.
		input_locked = false
		set_cards_enabled(true)


func game_completed() -> void:
	game_timer.stop()

	game_complete_sound.play()

	input_locked = true
	set_cards_enabled(false)

	var previous_best := SaveManager.get_best_score()
	var is_new_best := previous_best == 0 or moves < previous_best

	SaveManager.save_best_score(moves)

	print("PAIRNIX COMPLETE!")
	print("Moves: ", moves)
	print("Time: ", time_label.text)

	completion_result.text = "All 6 pairs matched!\n\nMoves: %d\n\n%s" % [
		moves,
		time_label.text
	]

	if is_new_best:
		best_score_result.text = "NEW BEST SCORE!"
	else:
		best_score_result.text = "Best Moves: %d" % SaveManager.get_best_score()

	completion_panel.visible = true


func _on_play_again_pressed() -> void:
	button_click_sound.play()

	await get_tree().create_timer(0.15).timeout

	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	button_click_sound.play()

	print("MAIN MENU BUTTON PRESSED")

	await get_tree().create_timer(0.15).timeout

	get_tree().change_scene_to_file(
		"res://Scenes/MainMenu/MainMenu.tscn"
	)

func _on_game_timer_timeout() -> void:
	elapsed_time += 1
	update_time_label()


func _on_pause_button_pressed() -> void:
	button_click_sound.play()

	game_timer.paused = true
	input_locked = true
	set_cards_enabled(false)

	pause_panel.visible = true


func _on_resume_button_pressed() -> void:
	button_click_sound.play()

	pause_panel.visible = false

	game_timer.paused = false
	input_locked = false
	set_cards_enabled(true)


func _on_pause_restart_pressed() -> void:
	print("PAUSE RESTART BUTTON PRESSED")

	button_click_sound.play()

	await get_tree().create_timer(0.15).timeout

	get_tree().reload_current_scene()


func _on_pause_main_menu_pressed() -> void:
	button_click_sound.play()

	await get_tree().create_timer(0.15).timeout

	get_tree().change_scene_to_file(
		"res://Scenes/MainMenu/MainMenu.tscn"
	)


func _on_game_main_menu_pressed() -> void:
	button_click_sound.play()

	await get_tree().create_timer(0.15).timeout

	get_tree().change_scene_to_file(
		"res://Scenes/MainMenu/MainMenu.tscn"
	)
