extends Node

signal game_overed
signal game_pused
signal game_played

enum GameState {
	PLAYING,
	GAME_OVER,
	PUSED
}

var game_state: GameState = GameState.PLAYING

func trigger_game_state(new_state: GameState):
	game_state = new_state
	if new_state == GameState.GAME_OVER:
		game_overed.emit()
		await get_tree().create_timer(3).timeout
		get_tree().reload_current_scene()
	elif new_state == GameState.PUSED:
		game_pused.emit()
	elif new_state == GameState.PLAYING:
		game_played.emit()
