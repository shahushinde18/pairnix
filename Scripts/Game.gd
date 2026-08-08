extends Control

const CARD_SCENE := preload("res://Scenes/Cards/Card.tscn")
const TOTAL_PAIRS := 6

@onready var card_grid: GridContainer = $CardGrid

var cards: Array[Control] = []


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
		card.setup_card(id, null)
		cards.append(card)
