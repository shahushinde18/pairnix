extends Control

signal card_pressed(card)

@onready var card_back: TextureRect = $CardPanel/CardBack
@onready var card_front: TextureRect = $CardPanel/CardFront
@onready var card_button: Button = $CardButton

var is_revealed := false
var is_matched := false
var card_id := -1


func _ready() -> void:
	card_back.visible = true
	card_front.visible = false
	card_button.disabled = false
	card_button.pressed.connect(_on_card_pressed)


func setup_card(id: int, front_texture: Texture2D) -> void:
	card_id = id
	card_front.texture = front_texture


func _on_card_pressed() -> void:
	if is_revealed or is_matched:
		return

	is_revealed = true
	card_back.visible = false
	card_front.visible = true

	card_pressed.emit(self)


func hide_card() -> void:
	if is_matched:
		return

	is_revealed = false
	card_back.visible = true
	card_front.visible = false


func set_matched() -> void:
	is_matched = true
	is_revealed = true

	card_back.visible = false
	card_front.visible = true

	card_button.disabled = true
