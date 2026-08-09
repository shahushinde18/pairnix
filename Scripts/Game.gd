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
	pairs_label.text = "Pairs: %d / %d" % [matched_pairs, TOTAL_PAIRS]
	moves_label.text = "Moves: %d" % moves

func game_completed() -> void:
	game_timer.stop()
	print("PAIRNIX COMPLETE!")
	print("Moves: ", moves)

	completion_result.text = "All 6 pairs matched!\nMoves: %d" % moves
	completion_panel.visible = true
		
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


func _on_card_pressed(card: Control) -> void:
	if input_locked:
		return

	if card.is_matched:
		return

	# First card
	if first_card == null:
		first_card = card
		return

	# Same card clicked twice
	if card == first_card:
		return

	# Second card
	second_card = card

	moves += 1
	update_labels()

	input_locked = true

	# Check whether the two cards match
	if first_card.card_id == second_card.card_id:
		print("MATCH FOUND - Pair ID: ", first_card.card_id)

		first_card.set_matched()
		second_card.set_matched()

		# Calculate matched pairs from the actual card state
		var matched_card_count := 0

		for game_card in cards:
			if game_card.is_matched:
				matched_card_count += 1

		matched_pairs = matched_card_count / 2
		update_labels()

		# Clear selection immediately
		first_card = null
		second_card = null
		input_locked = false

		print("MATCHED PAIRS: ", matched_pairs, " / ", TOTAL_PAIRS)

		if matched_pairs == TOTAL_PAIRS:
			game_completed()

	else:
		print("NO MATCH - hiding cards")

		await get_tree().create_timer(0.8).timeout

		# Make sure these references still exist before hiding
		if first_card != null:
			first_card.hide_card()

		if second_card != null:
			second_card.hide_card()

		first_card = null
		second_card = null
		input_locked = false
	
func _on_play_again_pressed() -> void:
		get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	print("MAIN MENU BUTTON PRESSED")		

func _on_game_timer_timeout() -> void:
	elapsed_time += 1
	update_time_label()


func update_time_label() -> void:
	time_label.text = "Time: %02d" % elapsed_time
