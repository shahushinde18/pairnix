extends Control

const SPLASH_DURATION := 2.0

func _ready() -> void:
	await get_tree().create_timer(SPLASH_DURATION).timeout
	get_tree().change_scene_to_file("res://Scenes/MainMenu/MainMenu.tscn")
