extends Node

const SAVE_PATH := "user://pairnix_save.cfg"


func save_best_score(moves: int) -> void:
	var current_best := get_best_score()


	if current_best == 0 or moves < current_best:
		var config := ConfigFile.new()

		config.set_value("score", "best_moves", moves)

		var error := config.save(SAVE_PATH)

		if error == OK:
			print("SAVE MANAGER - Best score saved: ", moves)
		else:
			print("SAVE MANAGER - ERROR saving score: ", error)
	else:
		print("SAVE MANAGER - Existing best is better: ", current_best)


func get_best_score() -> int:
	var config := ConfigFile.new()

	var error := config.load(SAVE_PATH)

	if error == OK:
		var best_moves = config.get_value("score", "best_moves", 0)
		return int(best_moves)

	return 0


func _on_back_button_pressed() -> void:
	pass # Replace with function body.

func save_sound_enabled(enabled: bool) -> void:
	var config := ConfigFile.new()

	config.load(SAVE_PATH)

	config.set_value("settings", "sound_enabled", enabled)

	var error := config.save(SAVE_PATH)

	if error == OK:
		print("SAVE MANAGER - Sound setting saved: ", enabled)
	else:
		print("SAVE MANAGER - ERROR saving sound setting: ", error)


func get_sound_enabled() -> bool:
	var config := ConfigFile.new()

	if config.load(SAVE_PATH) == OK:
		return bool(config.get_value("settings", "sound_enabled", true))

	return true
