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

var cards: Array[Control] = []

var first_card: Control = null
var second_card: Control = null

var input_locked := false


func _ready() -> void:
	create_cards()


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

	if first_card == null:
		first_card = card
		return

	if card == first_card:
		return

	second_card = card
	input_locked = true

	await get_tree().create_timer(0.8).timeout

	if first_card.card_id == second_card.card_id:
		first_card.set_matched()
		second_card.set_matched()
	else:
		first_card.hide_card()
		second_card.hide_card()

	first_card = null
	second_card = null
	input_locked = false
